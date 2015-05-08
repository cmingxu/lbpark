(function ( $ ) {
  var Utils = {
    proto_inheritance: function (base, child) {
      child.prototype = new base();
      child.prototype.constructor = base;
    },

    logger: function(mes) {
      console.log(mes);
    },

    uuid: function () {
      function guid() {
        function s4() {
          return Math.floor((1 + Math.random()) * 0x10000)
          .toString(16)
          .substring(1);
        }
        return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
          s4() + '-' + s4() + s4() + s4();
      }
    }

  };

  var STATE = {
    NOT_DRAW: 1,
    DRAWING: 2,
    EDITING: 3,
    DONE: 4
  };

  var ACTIONS = {
    DRAW_LINE: 1,
    EDIT_LINE: 2,
    EDIT_OBJ: 4,
    DONE_EDITING: 5,
    PLAIN: 6,
    RESET_CANVAS: 7,
    PAN: 8,
    DUMMY: 9,
  }

  function ParkMap(options) {
    var container = options.container;
    var width_in_meter = options.width_in_meter;
    var height_in_meter = options.height_in_meter;
    var html_markups =
      "<div id='pm_toolbar'><div class='pm_content' id='pm_toolbar_content'></div></div>" +
      "<div id='pm_content'>" +
      "<div id='pm_mesh_wrapper'>" +
      "<div id='pm_mesh_x_ruler' class='ruler'></div>" +
      "<div id='pm_mesh_y_ruler' class='ruler'></div>" +
      "<div id='pm_mesh'>Canvas </div>" +
      "<div id='pm_ele_editor'> <div id='pm_ele_editor_header' class='pm_header'></div> <div id='pm_ele_editor_content' class='pm_content'> <table></table></div> </div>" + 
      "</div>" +
      "</div>";

    ///////////////////////////////////////////////////////////////////////////
    //
    // Global helper methods
    //
    ///////////////////////////////////////////////////////////////////////////
    instance = this;
    this.objects = []; // list of objects & group with hierarchy
    this.action_queue = []; // pending for future usage

    this.synchronizor = {
      need_sync: false,
      last_sync: null,
      dump:  function() {
        obj = this;
        setInterval(function () {
          if(obj.need_sync){
            objects = [];
            instance.objects.forEach(function (shape) { objects.push(shape.as_json()); });
            $.ajax({type: 'POST', url: create_mesh_path, data: {objects: objects}, dataType: 'JSON'});
            obj.last_sync = (new Date()).getTime();
            obj.need_sync = false;
          }
        }, 2 * 1000);
      },

      load: function (json) {
        json.forEach(function (d) {
          switch (d.name) {
            case 'rect':
              shape = new Rect();
              break;
            case 'line':
              shape = new Line();
              break;
            case 'park_space':
              shape = new ParkSpace();
              break;
            case 'pillar':
              shape = new Pillar();
              break;
            case 'lift':
              shape = new Lift();
              break;
            case 'elevator':
              shape = new Elevator();
              break;
            case 'lane':
              shape = new Lane();
              break;
            default:
              break;
          }

          for(p in d.prop_list){ shape.prop_list[p].setValue(_.values(d.prop_list[p])[0]); }
          if(typeof shape.setStartPoint === "function"){
            shape.setStartPoint(new Point(
              parseFloat(shape.prop_list.left.css_value()),
              parseFloat(shape.prop_list.top.css_value())));
          }

          if(typeof shape.setEndPoint === "function"){
            shape.setEndPoint(new Point(
              shape.start_point.x_in_px + parseFloat(shape.prop_list.width.css_value()),
              shape.start_point.y_in_px + parseFloat(shape.height || shape.prop_list.height.css_value())));
          }
          shape.draw();

        });
      },
      set_need_sync: function () {
        this.need_sync = true;
      }
    };

    this.synchronizor.dump();

    this.context = {
      current_action: null,
      current_shapes: null
    }

    this.initialize = function () {
      container.html(html_markups);
      this.canvas = container.find("#pm_mesh");
      this.pm_ele_editor  = container.find("#pm_ele_editor");

      this.draw_backgroup();
      this.events_registration();

      instance.synchronizor.load(park_map_data);
    },


    this.draw_backgroup = function () {
      this.canvas.attr('height', 3000);
      this.canvas.attr('width', 3000);

      this.draw_toolbar_items();
      this.draw_ruler();
      this.add_mesh();
      this.enter_mesh_main_loop();
    },

    this.events_registration = function () {
      this.canvas_drag_event_registration();
    },

    this.draw_ruler = function () {
      var x_ruler_container = $("#pm_mesh_x_ruler");
      var y_ruler_container = $("#pm_mesh_y_ruler");
      ruler_max = Math.max(height_in_meter, width_in_meter)
      for(var i=0; i<ruler_max; i++){
        if(i%10 == 0){
          x_ruler_container.append($("<div class='big_interval_mark' data-value='" + i +"'>" +i+ "m</div>"));
          y_ruler_container.append($("<div class='big_interval_mark' data-value='" + (ruler_max - i) +"'>" + (ruler_max-i)+ "m</div>"));
        }else{
          x_ruler_container.append($("<div class='small_interval_mark' data-value='" + i +"'></div>"));
          y_ruler_container.append($("<div class='small_interval_mark' data-value='" + (ruler_max-i) +"'></div>"));
        }
      }

      x_ruler_container.find(".big_interval_mark, .small_interval_mark").on('mouseover', function () { });
      y_ruler_container.find(".big_interval_mark, .small_interval_mark").on('mouseover', function () { });
    },

    this.add_mesh = function () {
      table = "";
      for(var i=0; i<height_in_meter; i++){
        table += "<div class='mesh_line'>";
        for(var j=0; j<width_in_meter; j++){
          table += "<span data-x='" + j + "' data-y='"+ i +"' id='slot_" +j+ "_" + i+ "'></span>"
        }
        table += "</div>"
      }

      instance.canvas.html(table);
    }

    this.show_prop_list_window = function (shape) {
      self = this;
      this.pm_ele_editor.show();

      _.values(shape.prop_list).forEach(function (prop) {
        tmp = $(prop.to_html());
        tmp.find("select,input").on('change', function (val) {
          prop.setValue($(this).val());
          shape.update();
        });

        self.pm_ele_editor.find("#pm_ele_editor_content table").append(tmp);
      });
      this.pm_ele_editor.find("#pm_ele_editor_content table");
    };
    this.hide_prop_list_window = function (shape) {
      this.pm_ele_editor.hide();
      this.pm_ele_editor.find("#pm_ele_editor_content table").empty();
    };

    ///////////////////////////////////////////////////////////////////////////
    //
    // draw action items
    //
    ///////////////////////////////////////////////////////////////////////////

    this.draw_toolbar_items = function () {
      var ToolbarItem = function () {
        this.name = null;
        this.icon = null;
        this.cn_name = null;
        this.callback = null;

        this.as_html = function () {
          return "<div class='toolbaritem'><div class='toolbaritem_icon "+ this.icon +"'></div><div class='toolbaritem_name'> " +this.cn_name+ " </div></div>";
        }
      }

      var toolbar_items = [];

      var reset_canvas_item = new ToolbarItem();
      reset_canvas_item.name = "plain";
      reset_canvas_item.cn_name = "归位";
      reset_canvas_item.icon = 'plain';
      reset_canvas_item.callback = function () {
        var reset_canvas_action = new ResetCanvasAction();
        instance.context.current_action = null;
        instance.context.current_shapes = [];
        reset_canvas_action.take_effect_now();
      }
      toolbar_items.push(reset_canvas_item);


      var pan_item = new ToolbarItem();
      pan_item.name = "pan";
      pan_item.cn_name = "移动";
      pan_item.icon = 'pan';
      pan_item.callback = function () {
        var pan_action = new PanAction();
        // make sure context to previous state
        if(instance.context.current_action){
          instance.context.current_action.reset();
        }
        instance.context.current_action = pan_action;
        pan_action.take_effect_now();
      }
      toolbar_items.push(pan_item);

      var draw_line = new ToolbarItem();
      draw_line.name = "draw_line";
      draw_line.cn_name = "线";
      draw_line.icon = 'line';
      draw_line.callback = function () {
        var draw_line_action = new DrawLineAction();
        // make sure context to previous state
        if(instance.context.current_action){
          instance.context.current_action.reset();
        }
        instance.context.current_action = draw_line_action;
        draw_line_action.take_effect_now();
      }
      toolbar_items.push(draw_line);

      var draw_rect = new ToolbarItem();
      draw_rect.name = "draw_rect";
      draw_rect.cn_name = "矩形";
      draw_rect.icon = 'rect';
      draw_rect.callback = function () {
        var draw_rect_action = new DrawRectAction();
        draw_rect_action.shape = new Rect();
        // make sure context to previous state
        if(instance.context.current_action){
          instance.context.current_action.reset();
        }
        instance.context.current_action = draw_rect_action;
        draw_rect_action.take_effect_now();
      }
      toolbar_items.push(draw_rect);

      var draw_park_space = new ToolbarItem();
      draw_park_space.name = "draw_park_space";
      draw_park_space.cn_name = "车位";
      draw_park_space.icon = 'park_space';
      draw_park_space.callback = function () {
        var draw_park_space_action = new DrawParkSpaceAction();
        if(instance.context.current_action){
          instance.context.current_action.reset();
        }
        instance.context.current_action = draw_park_space_action;
        draw_park_space_action.take_effect_now();
      }
      toolbar_items.push(draw_park_space);

      var draw_lane = new ToolbarItem();
      draw_lane.name = "draw_lane";
      draw_lane.cn_name = "车道";
      draw_lane.icon = 'lane';
      draw_lane.callback = function () {
        var draw_lane_action = new DrawLaneAction();
        if(instance.context.current_action){
          instance.context.current_action.reset();
        }
        instance.context.current_action = draw_lane_action;
        draw_lane_action.take_effect_now();
      }
      toolbar_items.push(draw_lane);

      var draw_pillar = new ToolbarItem();
      draw_pillar.name = "draw_pillar";
      draw_pillar.cn_name = "柱子";
      draw_pillar.icon = 'pillar';
      draw_pillar.callback = function () {
        var draw_pillar_action = new DrawPillarAction();
        if(instance.context.current_action){
          instance.context.current_action.reset();
        }
        instance.context.current_action = draw_pillar_action;
        draw_pillar_action.take_effect_now();
      }
      toolbar_items.push(draw_pillar);

      var draw_lift = new ToolbarItem();
      draw_lift.name = "draw_lift";
      draw_lift.cn_name = "电梯";
      draw_lift.icon = 'lift';
      draw_lift.callback = function () {
        var draw_lift_action = new DrawLiftAction();
        if(instance.context.current_action){
          instance.context.current_action.reset();
        }
        instance.context.current_action = draw_lift_action;
        draw_lift_action.take_effect_now();
      }
      toolbar_items.push(draw_lift);

      var draw_elevator = new ToolbarItem();
      draw_elevator.name = "draw_elevator";
      draw_elevator.cn_name = "扶梯";
      draw_elevator.icon = 'elevator';
      draw_elevator.callback = function () {
        var draw_elevator_action = new DrawElevatorAction();
        if(instance.context.current_action){
          instance.context.current_action.reset();
        }
        instance.context.current_action = draw_elevator_action;
        draw_elevator_action.take_effect_now();
      }
      toolbar_items.push(draw_elevator);

      var toolbar = $("#pm_toolbar");
      var toolbar_content = $("#pm_toolbar_content");

      for(var i=0; i<toolbar_items.length; i++){
        item =$(toolbar_items[i].as_html());
        item.on('click', toolbar_items[i].callback);
        toolbar_content.append(item);
      }
    }

    /////////////////////////////////////////////////////////////
    //
    // Event handlers 
    //
    /////////////////////////////////////////////////////////////

    this.canvas_drag_event_registration = function () {
      var isDragging = false;
      var dragStartEventTriggered = false;

      instance.canvas.on('mousedown', function () {
        $(instance.canvas).mousemove(function() {
          isDragging = true;
          if(!dragStartEventTriggered){
            instance.canvas.trigger('drag_start', [event]);
            dragStartEventTriggered = true;
          }
          instance.canvas.trigger('draging', [event]);
        });
      }).on('mouseup', function () {
        var wasDragging = isDragging;
        isDragging = false;
        $(instance.canvas).unbind("mousemove");
        if (wasDragging) {
          instance.canvas.trigger('drag_stop', [event]);
          dragStartEventTriggered = false;
        }
      });
    }

    this.enter_mesh_main_loop = function () {
      function is_shape_selection(dblevent) {
        point = Point.from_event(event);
        for(var i=instance.objects.length-1; i>=0; i--){
