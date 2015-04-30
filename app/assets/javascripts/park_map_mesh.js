(function ( $ ) {
  var Utils = {
    proto_inheritance: function (base, child) {
      child.protoype = new base();
      child.protoype.constructor = base;
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
      "<div id='pm_ele_editor' class='hidden'> <div id='pm_ele_editor_header' class='pm_header'></div> <div id='pm_ele_editor_content' class='pm_content'> Element Editor</div> </div>" + 
      "</div>" +
      "</div>";

    instance = this;
    this.objects = []; // list of objects & group with hierarchy
    this.action_queue = []; // pending for future usage

    this.context = {
      current_action: null,
      current_shapes: null
    }

    this.initialize = function () {
      container.html(html_markups);
      this.canvas = container.find("#pm_mesh");

      this.draw_backgroup();
      this.events_registration();
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
      pan_item.icon = 'plain';
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

      var toolbar = $("#pm_toolbar");
      var toolbar_content = $("#pm_toolbar_content");

      for(var i=0; i<toolbar_items.length; i++){
        item =$(toolbar_items[i].as_html());
        item.on('click', toolbar_items[i].callback);
        toolbar_content.append(item);
      }
    }

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
        for(var i=0; i<instance.objects.length; i++){
          if(instance.objects[i].point_within_range(point)){
            return instance.objects[i];
          }
        }
        return null;
      }

      function action_dispatch(event_type, event) {
        dummy_action = new DummyAction();
        if(instance.context.current_action){
          instance.context.current_action.take_effect(new PmEvent(event_type, event));
        }else{
          dummy_action.take_effect(new PmEvent(event_type, event));
        }
      }

      instance.canvas.on('click', function () {
        action_dispatch('click', event);
      });

      instance.canvas.on('dblclick', function (trigger, event) {
        if(instance.context.current_action){ instance.context.current_action.reset(); instance.context.current_action = null;}
        if(shape = is_shape_selection(event)){
          if(shape.name == "line"){
            instance.context.current_action = new EditLineAction(shape);
            instance.context.current_action.take_effect_now();
          }
        }
        action_dispatch('dblclick', event);
      });

      instance.canvas.on('drag_start', function (trigger_event, event) {
        action_dispatch('drag_start', event);
      });

      instance.canvas.on('draging', function (trigger_event, event) {
        action_dispatch('draging', event);
      });

      instance.canvas.on('drag_stop', function (trigger_event, event) {
        action_dispatch('drag_stop', event);
      });
    }


    //action definiation
    var Action = function () {
      this.name = null;
      this.shape = null;

      this.take_effect = function () {
      }
      this.reset = function () {
      }
    };

    var ResetCanvasAction = function () {
      this.name = ACTIONS.RESET_CANVAS;
      this.take_effect_now = function () {
        instance.canvas.css("left", "20px").css("top", "-20px");
      }
    }

    var PanAction = function () {
      this.name = Action.PAN;
      this.drag_start_x = 0;
      this.drag_start_y = 0;

      this.original_cursor = 'default';

      this.take_effect_now = function () {
        instance.canvas.css('cursor', 'crossair');
      }

      this.reset = function () {
        instance.canvas.css('cursor', this.original_cursor);
      }

      this.take_effect = function(pm_event) {
        if(pm_event.event_type == "drag_start"){
          this.drag_start_x = pm_event.mouse_event.pageX;
          this.drag_start_y = pm_event.mouse_event.pageY;
        }
        if(pm_event.event_type == "drag_stop"){
          width  = pm_event.mouse_event.pageX - this.drag_start_x;
          height = pm_event.mouse_event.pageY - this.drag_start_y;

          width = parseInt(width / 10) * 10;
          height  = parseInt(height / 10) * 10;

          instance.canvas.css('left', "+=" + width);
          instance.canvas.css('top', "+=" + height);

          this.drag_start_x = 0;
          this.drag_start_y = 0;
        }
      }
    }


    var DrawLineAction = function () {
      this.name = ACTIONS.DRAW_LINE;
      this.shape = new Line();
      this.take_effect_now = function () {
        instance.canvas.css("cursor", "crosshair");
      }

      this.reset = function () {
        instance.canvas.css('cursor', 'default');
      }

      this.take_effect = function (pm_event) {
        offset_x = pm_event.mouse_event.pageX - instance.canvas.offset().left;
        offset_y = pm_event.mouse_event.pageY - instance.canvas.offset().top;

        if(pm_event.event_type == "drag_start"){
          this.shape.start_point = new Point(offset_x, offset_y);
        }

        if(pm_event.event_type == "draging"){
          this.shape.end_point = new Point(offset_x, offset_y);
          this.shape.drawing();
        }

        if(pm_event.event_type == "drag_stop"){
          this.shape.end_point = new Point(offset_x, offset_y);
          this.shape.draw();
          instance.context.current_action.reset();
          instance.context.current_action = null;
        }
      }
    }

    var EditLineAction = function (shape) {
      this.name = ACTIONS.EDIT_LINE;
      this.shape = shape;
      this.which_point_move = null;
      this.take_effect_now = function () {
        this.shape.editing();
      }

      this.reset = function () {
        this.shape.done_editing();
      }

      this.take_effect = function (pm_event) {
        function point_of_interest(event) {
          point = Point.from_event(event);
          handles = this.shape._line.find(".handle");
          div = null
          for(var i=0; i<handles.length; i++){
            if(point.within_div($(handles[i]))){
              div = $(handles[i]);
              break;
            }
          }

          if(this.div == null){
            return null;
          }

          if(div.hasClass("left_handle")){ return "left_handle"; }
          if(div.hasClass("right_handle")){ return "right_handle"; }
          if(div.hasClass("remove_handle")){ return "remove_handle"; }
        }

        if(pm_event.event_type == "click"){
          point_of_interest = point_of_interest(pm_event.mouse_event);
          if(point_of_interest == "remove_handle"){
            this.shape.remove();
          }
        }

        if(pm_event.event_type == "drag_start"){
          this.which_point_move = point_of_interest(pm_event.mouse_event);
        }

        if(pm_event.event_type == "draging"){
          if(this.which_point_move == null){ return null; }

          point = Point.from_event(pm_event.mouse_event);
          if(this.which_point_move == "left_handle"){
            this.shape.start_point = point;
          }else{
            this.shape.end_point = point;
          }
          this.shape.drawing();
        }

        if(pm_event.event_type == "drag_stop"){
          if(this.which_point_move == null){ return null; }

          point = Point.from_event(pm_event.mouse_event);
          if(this.which_point_move == 'left_handle'){
            this.shape.start_point = point;
          }else{
            this.shape.end_point = point;
          }
          this.shape.draw();
        }
      }
    }

    var DummyAction = function () {
      this.name = ACTIONS.DUMMY;

      this.take_effect = function (pm_event) {
        if(pm_event.event_type == "click"){
        }
      }
    }

    Utils.proto_inheritance(Action, DummyAction);
    Utils.proto_inheritance(Action, ResetCanvasAction);
    Utils.proto_inheritance(Action, PanAction);
    Utils.proto_inheritance(Action, DrawLineAction);

    //shapes definiation
    var Shape = function () {
      this.name = null;
      this.cn_name = null;
      this.state = STATE.NOT_DRAW;
      this.id   = Utils.uuid();
      this.draw = null;
      this.start_point = null;
      this.end_point = null;
    }

    var Line = function () {
      this.name = "line";
      this.cn_name = "线";
      this._line = $("<div class='line'><div class='handle left_handle'></div><div class='handle remove_handle'>X</div><div class='handle right_handle'></div></div>");
      this._line.css('border', 'none');
      this._line.css('height', '2px').css('background-color', 'red');
      this._line.css('position', 'absolute');
      this._line.css('transform-origin', "left top");

      this.point_within_range = function (point) {
        return this.distance_to_point(point) < 10;
      }

      this.prop = {
      }

      this._draw = function () {
        this._line.css('width', "" + this.start_point.distance(this.end_point) + "px");
        this._line.css('left', "" +  this.start_point.x_in_px + "px");
        this._line.css('top', "" +  this.start_point.y_in_px + "px");
        angle = this.start_point.angle(this.end_point);
        this._line.css('transform', "rotate(" +  angle + "deg)");
        if(!this._line.attr('append')){
          instance.canvas.append(this._line);
          instance.objects.push(this);
          this._line.attr('append', true);
        }
      }

      this.editing = function () {
        this.state = STATE.EDITING;
        this._line.find('.handle').show();
      }

      this.done_editing = function () {
        this.state = STATE.DRAWN;
        this._line.find('.handle').hide();
      }

      this.drawing = function () {
        this.state = STATE.DRAWING;
        this._draw();
      }

      this.draw = function () {
        this._draw();
        this.state = STATE.DRAWN;
        this.done_drawing();
      }

      this.done_drawing = function () {
      }

      this.remove = function () {
        this._line.remove();
      }

      this.distance_to_point = function(point) {
        x = point.x_in_px;
        y = point.y_in_px;

        x1 = this.start_point.x_in_px;
        y1 = this.start_point.y_in_px;

        x2 = this.end_point.x_in_px;
        y2 = this.end_point.y_in_px;

        var A = x - x1;
        var B = y - y1;
        var C = x2 - x1;
        var D = y2 - y1;

        var dot = A * C + B * D;
        var len_sq = C * C + D * D;
        var param = -1;
        if (len_sq != 0) //in case of 0 length line
          param = dot / len_sq;

        var xx, yy;

        if (param < 0) {
          xx = x1;
          yy = y1;
        }
        else if (param > 1) {
          xx = x2;
          yy = y2;
        }
        else {
          xx = x1 + param * C;
          yy = y1 + param * D;
        }

        var dx = x - xx;
        var dy = y - yy;
        return Math.sqrt(dx * dx + dy * dy);
      }
    }


    //shape property
    var ShapeProp = function () {
      this.css_key = null;
      this.ccs_value = null;
      this.name = null;
      this.cn_name = null;
      this.to_html = function () {
      };
      this.html_dom_type = function () {
      };
      this.html_dom_options = function () {
      }
    }

    var ThicknessProp = function () {
      this.css_key = "height";
      this.value   = 2;
      this.css_value = "2px";
      this.name = "thickness";
      this.cn_name = "宽度";
      this.to_html = function () {
        "<td>" + this.cn_name + "</td><td><select></select></td>"
      };

      this.html_dom_type = "select";
      this.html_dom_options = "2,3,4,5,6,7,8,9,10".split(",").map(function (v) { return "<option "+ (parseInt(v) == this.value ? 'selected' : '' ) +">" + v +"</option>"});
    }

    //point
    var Point = function(x, y){
      this.x_in_px = x;
      this.y_in_px = y;
      this.x_in_m  = 0;
      this.y_in_m  = 0;
      this.x_slot = parseInt(x / 10) * 10;
      this.y_slot = parseInt(y / 10) * 10;
      this.distance = function (other_point) {
        return parseInt(Math.sqrt( Math.pow(other_point.x_in_px - this.x_in_px, 2) + Math.pow(other_point.y_in_px - this.y_in_px, 2)));
      }

      this.angle = function (other_point) {
        diff_x = other_point.x_in_px - this.x_in_px;
        diff_y = other_point.y_in_px - this.y_in_px;

        return Math.atan2(diff_y, diff_x) * (180 / Math.PI);
      }

      this.within_div = function (dom) {
        dom_left_top_x = dom.offset().left - instance.canvas.offset().left;
        dom_left_top_y = dom.offset().top  - instance.canvas.offset().top;

        return this.x_in_px > dom_left_top_x && this.x_in_px < dom_left_top_x + dom.width() &&
          this.y_in_px > dom_left_top_y && this.y_in_px < dom_left_top_y + dom.height();
      }

    }

    Point.from_event = function (event) {
      x = event.pageX - instance.canvas.offset().left;
      y = event.pageY - instance.canvas.offset().top;

      return new Point(x, y);
    }

    var PmEvent = function (event_type, mouse_event) {
      this.event_type = event_type;
      this.mouse_event = mouse_event;
    }
  };


  $.fn.park_map = function( options ) {
    var settings = $.extend({
      width_in_meter: 200,
      height_in_meter: 200,
      draw_indicator: true,
      container: '#container'
    }, options );

    if(typeof settings.container === 'string')
      settings.container = $(settings.container);

    var park_map = new ParkMap(settings)
    park_map.initialize();
  };

}( jQuery ))







$(document).ready( function () {
  $("#container").park_map({});
});
