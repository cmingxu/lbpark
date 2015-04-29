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
    NEW_RECT: 1,
    NEW_ELLIPESE: 2,
    NEW_LINE: 3,
    EDIT_OBJ: 4,
    DONE_EDITING: 5,
    PLAIN: 6,
    RESET_CANVAS: 7
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
        table += "<div>";
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
      instance.canvas.on('click', function () {
      });

      instance.canvas.on('dblclick', function () {
      });

      instance.canvas.on('drag_start', function (trigger_event, event) {
        if(instance.context.current_action){
          instance.context.current_action.take_effect(new PmEvent("drag_start", event));
        }
      });

      instance.canvas.on('draging', function (trigger_event, event) {
        if(instance.context.current_action){
          instance.context.current_action.take_effect(new PmEvent("draging", event));
        }
      });

      instance.canvas.on('drag_stop', function (trigger_event, event) {
        if(instance.context.current_action){
          instance.context.current_action.take_effect(new PmEvent("drag_stop", event));
        }
      });
    }


    //action definiation
    var Action = function () {
      this.name = null;
      this.shape = null;

      this.take_effect = function () {
      }
    };

    var NewRectAction = function () {
      this.name = ACTIONS.NEW_RECT;
      this.shape = new Rect();
      this.cursor = "favicon.ico";
    };

    var ResetCanvasAction = function () {
      this.name = ACTIONS.RESET_CANVAS;
      this.take_effect_now = function () {
        instance.canvas.css("left", "20px").css("top", "-20px");
      }
    }

    var PanAction = function () {
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

    //shapes definiation
    var Shape = function () {
      this.name = null;
      this.cn_name = null;
      this.state = STATE.NOT_DRAW;
      this.id   = Utils.uuid();
      this.draw = null;

    }

    //point
    var Point = function(x, y){
      this.x_in_px = x;
      this.y_in_px = y;
      this.x_in_m  = 0;
      this.y_in_m  = 0;
    };

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
