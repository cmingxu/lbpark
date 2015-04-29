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
    PLAIN: 6
  }

  function ParkMap(options) {
    var container = options.container;
    var width_in_meter = options.width_in_meter;
    var height_in_meter = options.height_in_meter;
    var html_markups =
      "<div id='pm_toolbar'><div class='pm_content' id='pm_toolbar_content'></div></div>" +
      "<div id='pm_content'>" +
      "<div id='pm_project_window'> <div id='pm_project_window_header' class='pm_header'></div> <div class='pm_content' id='pm_project_window_content'>Project Window </div></div>" +
      "<div id='pm_container_canvas_wrapper'>" +
      "<div id='pm_container_canvas_x_ruler' class='ruler'></div>" +
      "<div id='pm_container_canvas_y_ruler' class='ruler'></div>" +
      "<canvas id='pm_container_canvas'>Canvas </div>" +
      "<div id='pm_ele_editor' class='hidden'> <div id='pm_ele_editor_header' class='pm_header'></div> <div id='pm_ele_editor_content' class='pm_content'> Element Editor</div> </div>" + 
      "</div>" +
      "</div>";

    instance = this;
    this.ctx = null;
    this.canvas = null;
    this.objects = []; // list of objects & group with hierarchy
    this.action_queue = []; // pending for future usage

    this.context = {
      current_action: null,
      current_shapes: null
    }

    this.initialize = function () {
      container.html(html_markups);
      this.canvas = container.find("#pm_container_canvas");
      this.ctx = container.find("#pm_container_canvas").get(0).getContext('2d');

      this.draw_backgroup();
      this.events_registration();
      this.canvas_drawing_core_loop();
    },


    this.draw_backgroup = function () {
      this.canvas.attr('height', 3000);
      this.canvas.attr('width', 3000);

      this.draw_toolbar_items();
      this.draw_ruler();
    },

    this.events_registration = function () {
      this.canvas_drag_event_registration();
    },

    this.draw_ruler = function () {
      var x_ruler_container = $("#pm_container_canvas_x_ruler");
      var y_ruler_container = $("#pm_container_canvas_y_ruler");
      ruler_max = Math.max(height_in_meter, width_in_meter)
      for(var i=0; i<ruler_max; i++){
        if(i%10 == 0){
          x_ruler_container.append($("<div class='big_interval_mark' data-value='" + i +"'>" +i+ "</div>"));
          y_ruler_container.append($("<div class='big_interval_mark' data-value='" + (ruler_max - i) +"'>" + (ruler_max-i)+ "</div>"));
        }else{
          x_ruler_container.append($("<div class='small_interval_mark' data-value='" + i +"'></div>"));
          y_ruler_container.append($("<div class='small_interval_mark' data-value='" + (ruler_max-i) +"'></div>"));
        }
      }

      x_ruler_container.find(".big_interval_mark, .small_interval_mark").on('mouseover', function () { });
      y_ruler_container.find(".big_interval_mark, .small_interval_mark").on('mouseover', function () { });
    },

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
      // new rectangle toolbar item
      var new_rectangle_item = new ToolbarItem();
      new_rectangle_item.name = "矩形";
      new_rectangle_item.cn_name = "矩形";
      new_rectangle_item.icon = 'rect';
      new_rectangle_item.callback = function () {
        var new_rect_action = new NewRectAction();
        instance.context.current_action = new_rect_action;
        instance.context.current_shapes = [new_rect_action.shape];
        instance.canvas.css("cursor", "url(/assets/" + instance.context.current_action.cursor + "), crosshair");
        Utils.logger(instance.context);
      }
      toolbar_items.push(new_rectangle_item);

      var plain_item = new ToolbarItem();
      plain_item.name = "plain";
      plain_item.cn_name = "恢复";
      plain_item.icon = 'plain';
      plain_item.callback = function () {
        var plain_action = new PlainAction();
        instance.context.current_action = plain_action;
        instance.context.current_shapes = [];
        instance.canvas.css("cursor", "url(/assets/" + instance.context.current_action.cursor + "), crosshair");
        Utils.logger(instance.context);
      }
      toolbar_items.push(plain_item);

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
    },

    this.canvas_drawing_core_loop = function () {
      instance.canvas.on('click', function () {
      });

      instance.canvas.on('dbclick', function () {
      });

      instance.canvas.on('drag_start', function (event_trigger, mouse_event) {
        if(!instance.context.current_action){ return }
        if(instance.context.current_action.name == ACTIONS.NEW_RECT){
          instance.context.current_shapes[0].start_drawing(mouse_event);
        }
      });

      instance.canvas.on('draging', function (event_trigger, mouse_event) {
        if(!instance.context.current_action){ return }
        if(instance.context.current_action.name == ACTIONS.NEW_RECT){
          instance.context.current_shapes[0].drawing(mouse_event);
        }
      });

      instance.canvas.on('drag_stop', function (event_trigger, mouse_event) {
        if(!instance.context.current_action){ return }
        if(instance.context.current_action.name == ACTIONS.NEW_RECT){
          instance.context.current_shapes[0].done_drawing(mouse_event);
          instance.context.current_action = null;
          instance.context.current_shapes = [];
        }
      });

    }



    //action definiation
    var Action = function () {
      this.name = null;
      this.shape = null;

      this.effect = function () {
      }
    };

    var NewRectAction = function () {
      this.name = ACTIONS.NEW_RECT;
      this.shape = new Rect();
      this.cursor = "favicon.ico";
    };

    var PlainAction = function () {
      this.name = ACTIONS.PLAIN;
      this.cursor = "pointer";
    }

    //shapes definiation
    var Shape = function () {
      this.name = null;
      this.cn_name = null;
      this.state = STATE.NOT_DRAW;
      this.id   = Utils.uuid();
      this.draw = null;

    }

    var Rect = function () {
      this.name = "Rect";
      this.cn_name = "矩形";
      this.start_point = null;
      this.end_point   = null;
      this._draw = function (point) {
        height = Math.max(0, point.y_in_px - this.start_point.y_in_px);
        width = Math.max(0, point.x_in_px - this.start_point.x_in_px);
        instance.ctx.fillStyle = "#FF0000";
        //instance.ctx.clearRect(this.start_point.x_in_px, this.start_point.y_in_px, width, height);
        instance.ctx.strokeRect(this.start_point.x_in_px, this.start_point.y_in_px, width, height);
      },

      this.draw = function () {
      },

      this.start_drawing = function (event) {
        this.start_point = new Point(event.offsetX, event.offsetY);
      },

      this.drawing = function (event) {
        //this._draw(new Point(event.offsetX, event.offsetY));
      },

      this.done_drawing = function (event) {
        this.end_point = new Point(event.offsetX, event.offsetY);
        this._draw(this.end_point);
      }
    }

    Utils.proto_inheritance(Shape, Rect);

    //point
    var Point = function(x, y){
      this.x_in_px = x;
      this.y_in_px = y;
      this.x_in_m  = 0;
      this.y_in_m  = 0;
    };
  };


  $.fn.park_map = function( options ) {
    var settings = $.extend({
      width_in_meter: 300,
      height_in_meter: 300,
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
