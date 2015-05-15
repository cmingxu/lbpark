(function ( $ ) {
  var Utils = {
    proto_inheritance: function (base, child) {
      child.prototype = new base();
      child.prototype.constructor = base;
    }
  };

  var STATE = {
    NOT_DRAW: 1,
    DRAWING: 2,
    EDITING: 3,
    DONE: 4
  };

  function ParkMapWechatRender(options) {
    var container = options.container;
    var width_in_meter = options.width_in_meter;
    var height_in_meter = options.height_in_meter;
    var html_markups =
      "<div id='pm_content'>" +
      "<div id='pm_list'></div>" +
      "<div id='pm_close'></div>" +
      "<div id='pm_mesh_wrapper'>" +
      "<div id='pm_mesh'> </div>" +
      "</div>" +
      "</div>";

    ///////////////////////////////////////////////////////////////////////////
    //
    // Global helper methods
    //
    ///////////////////////////////////////////////////////////////////////////
    instance = this;
    this.objects = []; // list of objects & group with hierarchy


    this.context = {
      current_action: null,
      current_shapes: null
    }

    this.initialize = function () {
      container.html(html_markups);
      this.canvas = container.find("#pm_mesh");
      this.pm_ele_editor  = container.find("#pm_ele_editor");
      this.close_btn  = container.find("#pm_close");
      this.pm_list  = container.find("#pm_list");
      this.close_btn.on('click', instance.hide);


      this.draw_backgroup();
      this.draw_pm_list(Object.keys(park_maps)[0]);
      instance.synchronizor.load(park_maps, Object.keys(park_maps)[0]);
    },


    this.draw_pm_list = function (name) {
      this.pm_list.empty();
      for(var i=0; i<Object.keys(park_maps).length; i++){
        if(Object.keys(park_maps)[i] == name){
          pm_name_item = "<div class='pm_list_item active'>" + Object.keys(park_maps)[i] +"</div>";
        }else{
          pm_name_item = "<div class='pm_list_item'>" + Object.keys(park_maps)[i] +"</div>";
        }
        this.pm_list.append(pm_name_item);
        this.pm_list.find(".pm_list_item").on('click', function () {
          instance.draw_pm_list($(this).text());
          instance.draw_other_map($(this).text());
        });
      }
    }

    this.draw_other_map = function (new_map_name) {
      instance.synchronizor.load(park_maps, new_map_name);
    }

    this.hide = function () {
      $(options.container).hide();
    }

    this.show = function () {
      $(options.container).show();
    }

    this.synchronizor = {
      load: function (json, pm_name) {
        instance.canvas.empty();
        instance.objects = [];

        json = json[pm_name];
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

          shape.uuid = d.uuid;

          for(p in d.prop_list){ shape.prop_list[p].setValue(_.values(d.prop_list[p])[0]); }
          if(typeof shape.setStartPoint === "function"){
            shape.setStartPoint(new Point(
              parseFloat(shape.prop_list.left.css_value()),
              parseFloat(shape.prop_list.top.css_value())));
          }

          if(typeof shape.setEndPoint === "function"){
            width  = parseFloat(shape.width_in_px || shape.prop_list.width.css_value());
            if(shape.height_in_px){
              height = shape.height_in_px;
            }else if(shape.prop_list.thickness){
              height = shape.prop_list.thickness.css_value;
            }else{
              height = shape.prop_list.height.css_value();
            }
            height = parseFloat(height);

            shape.setEndPoint(new Point(
              shape.start_point.x_in_px + width,
              shape.start_point.y_in_px + height));
          }
          shape.draw();

        });
      }
    };


    this.draw_backgroup = function () {
      this.canvas.attr('height', 3000);
      this.canvas.attr('width', 3000);
      this.enter_mesh_main_loop();
    },

    this.park_space_selected = function (park_space) {
      $("#coupon_issued_park_sapce").val(park_space_datas[park_space.uuid]);
      instance.hide();
    };


    this.enter_mesh_main_loop = function () {
      var PmEvent = function (event_type, mouse_event) {
        this.event_type = event_type;
        this.mouse_event = mouse_event;
      }
      function is_shape_selection(event) {
        point = Point.from_event(event);
        for(var i=instance.objects.length-1; i>=0; i--){
          if(instance.objects[i].point_within_range(point)){
            return instance.objects[i];
          }
        }
        return null;
      }


      instance.canvas.on('click', function (event) {
        shape = is_shape_selection(event);
        if(shape && shape.name == "park_space"){
          instance.park_space_selected(shape);
        }
      });

    }



    //////////////////////////////////////////////////////////////////////////////
    //
    //shapes definiation
    //
    //////////////////////////////////////////////////////////////////////////////

    var Shape = function () {
      this.name = null;
      this.cn_name = null;
      this.state = STATE.NOT_DRAW;
      this.draw = null;
      this.start_point = null;
      this.end_point = null;
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
      this.value   = "2px";
      this.css_value = "2px";
      this.name = "thickness";
      this.cn_name = "宽度";
      this.to_html = function () { return "<tr><td>" + this.cn_name + "</td><td><select>" + this.html_dom_options + "</select></td><tr>"; };
      this.html_dom_type = "select";
      this.html_dom_options = "2,3,4,5,6,7,8,9,10".split(",").map(function (v) { return "<option value='" +v+ "px'"+ (parseInt(v) == this.value ? 'selected' : '' ) +">" + v +"</option>"});
      this.setValue = function (val) {
        this.value = this.css_value = val;
      }

      this.to_json = function () {
        return {"height": this.css_value }
      }
    }

    var ColorProp = function () {
      this.css_key = "background-color";
      this.css_value = "#81e1ec";
      this.value = "#81e1ec";
      this.name = 'color';
      this.cn_name = "背景色";
      this.to_html = function () {  return "<tr><td>" + this.cn_name + "</td><td><input value='" +this.css_value+ "' type='input'/></td></tr>";};
      this.html_dom_type = 'colorpicker';
      this.setValue = function (val) {
        this.value = this.css_value = val;
      }
      this.to_json = function () {
        return {"background-color": this.css_value }
      }
    }

    var LeftBorderProp = function () {
      this.css_key = "border-left";
      this.css_value = "2px solid gray";
      this.value = "2px solid gray";
      this.name  = "border-left";
      this.cn_name = "左边框";
      this.to_html = function () {   return "<tr><td>" + this.cn_name + "</td><td><input value='" +this.css_value+ "' type='input'/></td></tr>";};
      this.html_dom_type = 'input';
      this.setValue = function (val) { this.value = this.css_value = val; }
      this.to_json = function () {
        return {"border-left": this.css_value }
      }
    }

    var RightBorderProp = function () {
      this.css_key = "border-right";
      this.css_value = "2px solid gray";
      this.value = "2px solid gray";
      this.name  = "border-right";
      this.cn_name = "右边框";
      this.to_html = function () {   return "<tr><td>" + this.cn_name + "</td><td><input value='" +this.css_value+ "' type='input'/></td></tr>";};
      this.html_dom_type = 'input';
      this.setValue = function (val) { this.value = this.css_value = val; }
      this.to_json = function () {
        return {"border-right": this.css_value }
      }
    }

    var TopBorderProp = function () {
      this.css_key = "border-top";
      this.css_value = "2px solid gray";
      this.value = "2px solid gray";
      this.name  = "border-top";
      this.cn_name = "上边框";
      this.to_html = function () {   return "<tr><td>" + this.cn_name + "</td><td><input value='" +this.css_value+ "' type='input'/></td></tr>";};
      this.html_dom_type = 'input';
      this.setValue = function (val) { this.value = this.css_value = val; }
      this.to_json = function () {
        return {"border-top": this.css_value }
      }
    }

    var BottomBorderProp = function () {
      this.css_key = "border-bottom";
      this.css_value = "2px solid gray";
      this.value = "2px solid gray";
      this.name  = "border-bottom";
      this.cn_name = "下边框";
      this.to_html = function () {   return "<tr><td>" + this.cn_name + "</td><td><input value='" +this.css_value+ "' type='input'/></td></tr>";};
      this.html_dom_type = 'input';
      this.setValue = function (val) { this.value = this.css_value = val; }

      this.to_json = function () {
        return {"border-bottom": this.css_value }
      }
    }

    var AngleProp = function () {
      this.shape = null;
      this.css_key = "transform";
      this.css_value = "rotate(0deg)";
      this.value = "rotate(0deg)";
      this.name  = "rotate";
      this.cn_name = "角度";
      this.to_html = function () {   return "<tr><td>" + this.cn_name + "</td><td><input value='" +this.css_value+ "' type='input'/></td></tr>";};
      this.html_dom_type = 'input';
      this.setValue = function (val) { this.value = this.css_value = val; }
      this.to_json = function () {
        return {"transform": this.css_value }
      }
    }

    var TopProp = function () {
      this.shape = null;
      this.css_key = "top";
      this.css_value =  function () { return this.shape._rect.css('top'); };
      this.value = function () { return this.shape._rect.css('top'); };
      this.name  = "top";
      this.cn_name = "上";
      this.to_html = function () {   return "<tr><td>" + this.cn_name + "</td><td><input value='" +this.css_value() + "' type='input'/></td></tr>";};
      this.html_dom_type = 'input';
      this.setValue = function (val) { this.shape._rect.css('top', val); }

      this.to_json = function () {
        return {"top": this.css_value() }
      }
    }

    var LeftProp = function () {
      this.shape = null;
      this.css_key = "left";
      this.css_value =  function () { return this.shape._rect.css('left'); };
      this.value = function () { return this.shape._rect.css('left'); };
      this.name  = "left";
      this.cn_name = "左";
      this.to_html = function () {   return "<tr><td>" + this.cn_name + "</td><td><input value='" +this.css_value() + "' type='input'/></td></tr>";};
      this.html_dom_type = 'input';
      this.setValue = function (val) {
        this.shape._rect.css('left', val);
      }
      this.to_json = function () {
        return {"left": this.css_value() }
      }
    }

    var HeightProp = function () {
      this.shape = null;
      this.css_key = "height";
      this.css_value = function () { return this.shape._rect.css('height'); }
      this.value =  function () { return this.shape._rect.css('height'); }
      this.name  = "height";
      this.cn_name = "高度";
      this.to_html = function () {   return "<tr><td>" + this.cn_name + "</td><td><input value='" +this.css_value() + "' type='input'/></td></tr>";};
      this.html_dom_type = 'input';
      this.setValue = function (val) {
        this.shape._rect.css('height', val);
      }
      this.to_json = function () {
        return {"height": this.css_value() }
      }
    }

    var WidthProp = function () {
      this.shape = null;
      this.css_key = "width";
      this.css_value = function () { return this.shape._rect.css('width'); }
      this.value = function () { return this.shape._rect.css('width'); }
      this.name  = "width";
      this.cn_name = "长度";
      this.to_html = function () {   return "<tr><td>" + this.cn_name + "</td><td><input value='" +this.css_value() + "' type='input'/></td></tr>";};
      this.html_dom_type = 'input';
      this.setValue = function (val) { this.shape._rect.css('width', val); }
      this.to_json = function () {
        return {"width": this.css_value() }
      }
    }


    var LaneImageProp = function () {
      this.shape = null;
      this.css_key = "background-image";
      this.css_value = function () { return this.shape._rect.data('direction'); }
      this.value = function () { return this.shape._rect.data('direction'); }
      this.name  = "background-image";
      this.cn_name = "图片";
      this.to_html = function () { return "<tr><td>" + this.cn_name + "</td><td><select>" + this.html_dom_options + "</select></td><tr>"; };
      this.html_dom_type = "select";
      this.html_dom_options = ["double", "left", "right", "right_top", "right_bottom", "left_top", "left_bottom"].map(function (v) { return "<option "+ (parseInt(v) == this.value ? 'selected' : '' ) +">" + v +"</option>"});
      this.setValue = function (val) {
        this.shape._rect.removeClass(["double", "left", "right", "right_top", "right_bottom", "left_top", "left_bottom"].map(function (d) {
          return "lane_" + d;
        }).join(" " )).addClass("lane_" + val);
      }
      this.to_json = function () {
        return {"width": this.css_value() }
      }
    }


    var Line = function () {
      this.name = "line";
      this.cn_name = "线";
      this._rect = $("<div class='line'><div class='handle left_handle'></div><div class='handle remove_handle'>X</div><div class='handle right_handle'></div></div>");
      this._rect.css('border', 'none');
      this._rect.css('position', 'absolute');
      this._rect.css('transform-origin', "left top");

      this.point_within_range = function (point) {
        return this.distance_to_point(point) < 10;
      }

      this.setStartPoint = function (new_start_point) {
        this.start_point = new_start_point;
        this._update_cordinate();
      }

      this.setEndPoint = function (new_end_point) {
        this.end_point = new_end_point;
        this._update_cordinate();
      }

      this._update_cordinate = function () {
        this.prop_list.top.setValue(this.start_point.y_in_px + "px");
        this.prop_list.left.setValue(this.start_point.x_in_px + "px");
        if(this.end_point){
          this.prop_list.width.setValue(this.end_point.x_distance(this.start_point) + "px")
          angle = this.start_point.angle(this.end_point);
          this.prop_list.rotate.setValue("rotate(" + angle + "deg)");
        }
      }

      this.prop_list = {};
      line = this;
      [new ThicknessProp(), new ColorProp(), new TopProp(), new LeftProp(), new WidthProp(), new AngleProp()].map(function (prop) {
        prop.shape = line;
        line.prop_list[prop.name] = prop;
      });

      this.update = function () {
        this._draw();
      }

      this._draw = function () {
        for(prop_name in this.prop_list){
          if( typeof this.prop_list[prop_name].css_value === 'function'){
            this._rect.css(this.prop_list[prop_name].css_key, this.prop_list[prop_name].css_value());
          }else{
            this._rect.css(this.prop_list[prop_name].css_key, this.prop_list[prop_name].css_value);
          }
        }
        if(!this._rect.attr('append')){
          instance.canvas.append(this._rect);
          instance.objects.push(this);
          this._rect.attr('append', true);
        }
      }

      this.draw = function () {
        this._draw();
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

      this.as_json = function () {
        defaults = {
          name: 'line',
          prop_list: {}
        };

        for(prop in this.prop_list){
          defaults.prop_list[prop] = this.prop_list[prop].to_json();
        }

        return defaults;

      }
    }


    var Rect = function () {
      this.name = "rect";
      this.cn_name = "矩形";
      this._rect = $("<div class='rect'><div class='rect_handle rect_left_handle'></div><div class='rect_handle rect_remove_handle'>X</div><div class='rect_handle rect_right_handle'></div><div class='rect_handle rect_move_handle'></div><div class='rect_handle rect_rotate_handle'></div></div>");
      this._rect.css('position', 'absolute');
      this._rect.css('transform-origin', "center");

      this.width = function () {
        return this.end_point.x_in_px - this.start_point.x_in_px;
      }

      this.height = function () {
        return this.end_point.y_in_px - this.start_point.y_in_px;
      }

      this.center = function () {
        return new Point((this.end_point.x_in_px + this.start_point.x_in_px) / 2, (this.end_point.y_in_px + this.start_point.y_in_px) / 2);
      }

      this.setStartPoint = function (new_start_point) {
        this.start_point = new_start_point;
        this._update_cordinate();
      }

      this.setEndPoint = function (new_end_point) {
        this.end_point = new_end_point;
        this._update_cordinate();
      }

      this._update_cordinate = function () {
        this.prop_list.top.setValue(this.start_point.y_in_px + "px");
        this.prop_list.left.setValue(this.start_point.x_in_px + "px");
        if(this.end_point && this.prop_list.width && this.prop_list.height){
          this.prop_list.width.setValue(this.end_point.x_distance(this.start_point) + "px")
          this.prop_list.height.setValue(this.end_point.y_distance(this.start_point) + "px")
        }
      }

      this.point_within_range = function (point) {
        return point.x_in_px > this.start_point.x_in_px && point.x_in_px < this.end_point.x_in_px &&
          point.y_in_px > this.start_point.y_in_px && point.y_in_px < this.end_point.y_in_px;
      }

      this.prop_list = {};
      rect = this;
      [new ColorProp(), new LeftBorderProp(), new RightBorderProp(), new TopBorderProp(),
        new BottomBorderProp(), new AngleProp(), new TopProp(), new LeftProp(), new WidthProp(), new HeightProp()].map(function (prop) {
          prop.shape = rect;
          rect.prop_list[prop.name] = prop;
        });


        this.prop_list.color.setValue("#9bd23c");

        this.update = function () {
          this._draw();
        }

        this._draw = function () {
          for(prop_name in this.prop_list){
            if( typeof this.prop_list[prop_name].css_value === 'function'){
              this._rect.css(this.prop_list[prop_name].css_key, this.prop_list[prop_name].css_value());
            }else{
              this._rect.css(this.prop_list[prop_name].css_key, this.prop_list[prop_name].css_value);
            }
          }
          if(!this._rect.attr('append')){
            instance.canvas.append(this._rect);
            instance.objects.push(this);
            this._rect.attr('append', true);
          }
        }

        this.draw = function () {
          this._draw();
        }
    }

    Utils.proto_inheritance(Shape, Line);
    Utils.proto_inheritance(Shape, Rect);

    var ParkSpace = function () {
      park_space = this;
      this.height_in_px = 50;
      this.width_in_px = 30;

      this.name = "park_space";
      this.cn_name = "车位";
      this._rect = $("<div class='park_space'><div class='park_space_handle park_space_remove_handle'>X</div><div class='park_space_handle park_space_move_handle'></div><div class='park_space_handle park_space_rotate_handle'></div><div class='park_space_name'></div></div>");
      this._rect.css('position', 'absolute');
      this._rect.css('transform-origin', "center");
      this.prop_list = {};
      _.each([new AngleProp(), new TopProp(), new LeftProp()], function (prop) { park_space.prop_list[prop.name] = prop; prop.shape = park_space; });

      this.set_center = function (center) {
        this.center_point = center;
        this.prop_list.top.setValue(this.center_point.y_in_px - 15);
        this.prop_list.left.setValue(this.center_point.x_in_px - 15);
        this.start_point = new Point(this.center_point.x_in_px - 15, this.center_point.y_in_px - 25);
        this.end_point   = new Point(this.center_point.x_in_px + 15, this.center_point.y_in_px + 25);
      }

      this.update_name = function () {
        park_space = park_space_datas[this.uuid]
        if(!park_space) return;
        if(park_space){
          this._rect.find(".park_space_name").html(park_space);
        }
      }

      this._draw = function () {
        this.update_name();

        for(prop_name in this.prop_list){
          if( typeof this.prop_list[prop_name].css_value === 'function'){
            this._rect.css(this.prop_list[prop_name].css_key, this.prop_list[prop_name].css_value());
          }else{
            this._rect.css(this.prop_list[prop_name].css_key, this.prop_list[prop_name].css_value);
          }
        }
        this._rect.css('background-color', 'white');
        this._rect.css('height', '50px');
        this._rect.css('width', '30px');
        if(!this._rect.attr('append')){
          instance.canvas.append(this._rect);
          instance.objects.push(this);
          this._rect.attr('append', true);
        }

      }

    }
    Utils.proto_inheritance(Rect, ParkSpace);


    var Lane = function () {
      lane = this;
      this.height_in_px = 50;
      this.name = "lane";
      this.cn_name = "车道";
      this._rect = $("<div class='lane'><div class='lane_handle lane_remove_handle'>X</div><div class='lane_handle lane_right_handle'></div><div class='lane_handle lane_move_handle'></div><div class='lane_handle lane_rotate_handle'></div></div>");
      this._rect.css('position', 'absolute');
      this._rect.css('transform-origin', "center");

      this.setStartPoint = function (new_start_point) {
        this.start_point = new_start_point;
        this._update_cordinate();
      }

      this.setEndPoint = function (new_end_point) {
        this.end_point = new_end_point;
        this._update_cordinate();
      }

      this._update_cordinate = function () {
        this.prop_list.top.setValue(this.start_point.y_in_px + "px");
        this.prop_list.left.setValue(this.start_point.x_in_px + "px");
        if(this.end_point){ this.prop_list.width.setValue(this.end_point.x_distance(this.start_point) + "px") }
      }


      this.width = function () {
        return this.end_point.x_in_px - this.start_point.x_in_px;
      }

      this.height = function () {
        return this.end_point.y_in_px - this.start_point.y_in_px;
      }

      this.center = function () {
        return new Point((this.end_point.x_in_px + this.start_point.x_in_px) / 2, (this.end_point.y_in_px + this.start_point.y_in_px) / 2);
      }

      this.point_within_range = function (point) {
        return point.x_in_px > this.start_point.x_in_px && point.x_in_px < this.end_point.x_in_px &&
          point.y_in_px > this.start_point.y_in_px && point.y_in_px < this.end_point.y_in_px;
      }

      this.prop_list = {};
      _.each([new AngleProp(), new WidthProp(), new TopProp(), new LeftProp(), new LaneImageProp()], function (prop) { lane.prop_list[prop.name] = prop; prop.shape = lane;});

      this.update = function () {
        this._draw();
      }

      this._draw = function () {
        for(prop_name in this.prop_list){
          if( typeof this.prop_list[prop_name].css_value === 'function'){
            this._rect.css(this.prop_list[prop_name].css_key, this.prop_list[prop_name].css_value());
          }else{
            this._rect.css(this.prop_list[prop_name].css_key, this.prop_list[prop_name].css_value);
          }
        }
        this._rect.css('height', "50px");

        if(!this._rect.attr('append')){
          instance.canvas.append(this._rect);
          instance.objects.push(this);
          this._rect.attr('append', true);
        }

      }

    }

    Utils.proto_inheritance(Rect, Lane);

    var Pillar = function () {
      this.width_in_px = 20;
      this.height_in_px = 20;
      this.name = "pillar";
      this.cn_name = "柱子";
      this._rect = $("<div class='pillar'><div class='pillar_handle pillar_remove_handle'>X</div><div class='pillar_handle pillar_move_handle'></div></div>");
      this._rect.css('position', 'absolute');
      this._rect.css('transform-origin', "center");

      this.width = function () {
        return this.end_point.x_in_px - this.start_point.x_in_px;
      }

      this.height = function () {
        return this.end_point.y_in_px - this.start_point.y_in_px;
      }

      this.center = function () {
        return new Point((this.end_point.x_in_px + this.start_point.x_in_px) / 2, (this.end_point.y_in_px + this.start_point.y_in_px) / 2);
      }

      this.set_center = function (center) {
        this.center_point = center;
        this.prop_list.top.setValue(this.center_point.y_in_px - 10);
        this.prop_list.left.setValue(this.center_point.x_in_px - 10);
        this.start_point = new Point(this.center_point.x_in_px - 10, this.center_point.y_in_px - 10);
        this.end_point   = new Point(this.center_point.x_in_px + 10, this.center_point.y_in_px + 10);
      }

      this.point_within_range = function (point) {
        return point.x_in_px > this.start_point.x_in_px && point.x_in_px < this.end_point.x_in_px &&
          point.y_in_px > this.start_point.y_in_px && point.y_in_px < this.end_point.y_in_px;
      }

      this.prop_list = {};
      rect = this;
      [new ColorProp(), new TopProp(), new LeftProp()].map(function (prop) {
        prop.shape = rect;
        rect.prop_list[prop.name] = prop;
      });


      this.prop_list.color.setValue("#9bd23c");

      this._draw = function () {
        for(prop_name in this.prop_list){
          if( typeof this.prop_list[prop_name].css_value === 'function'){
            this._rect.css(this.prop_list[prop_name].css_key, this.prop_list[prop_name].css_value());
          }else{
            this._rect.css(this.prop_list[prop_name].css_key, this.prop_list[prop_name].css_value);
          }
        }
        this._rect.css('height', '20px');
        this._rect.css('width', '20px');
        if(!this._rect.attr('append')){
          instance.canvas.append(this._rect);
          instance.objects.push(this);
          this._rect.attr('append', true);
        }
      }

    }

    Utils.proto_inheritance(Rect, Pillar);


    var Lift = function () {
      this.height_in_px = this.width_in_px = 25;
      this.name = "lift";
      this.cn_name = "电梯";
      this._rect = $("<div class='lift'><div class='lift_handle lift_remove_handle'>X</div><div class='lift_handle lift_move_handle'></div></div>");
      this._rect.css('position', 'absolute');
      this._rect.css('transform-origin', "center");

      this.width = function () {
        return this.end_point.x_in_px - this.start_point.x_in_px;
      }

      this.height = function () {
        return this.end_point.y_in_px - this.start_point.y_in_px;
      }


      this.set_center = function (center) {
        this.center_point = center;
        this.prop_list.top.setValue(this.center_point.y_in_px - 25);
        this.prop_list.left.setValue(this.center_point.x_in_px - 25);
        this.start_point = new Point(this.center_point.x_in_px - 25, this.center_point.y_in_px - 25);
        this.end_point   = new Point(this.center_point.x_in_px + 25, this.center_point.y_in_px + 25);
      }
      this.center = function () {
        return new Point((this.end_point.x_in_px + this.start_point.x_in_px) / 2, (this.end_point.y_in_px + this.start_point.y_in_px) / 2);
      }

      this.point_within_range = function (point) {
        return point.x_in_px > this.start_point.x_in_px && point.x_in_px < this.end_point.x_in_px &&
          point.y_in_px > this.start_point.y_in_px && point.y_in_px < this.end_point.y_in_px;
      }

      this.prop_list = {};
      rect = this;
      [new TopProp(), new LeftProp()].map(function (prop) {
        prop.shape = rect;
        rect.prop_list[prop.name] = prop;
      });

      this._draw = function () {
        for(prop_name in this.prop_list){
          if( typeof this.prop_list[prop_name].css_value === 'function'){
            this._rect.css(this.prop_list[prop_name].css_key, this.prop_list[prop_name].css_value());
          }else{
            this._rect.css(this.prop_list[prop_name].css_key, this.prop_list[prop_name].css_value);
          }
        }
        this._rect.css('height', '50px');
        this._rect.css('width', '50px');
        if(!this._rect.attr('append')){
          instance.canvas.append(this._rect);
          instance.objects.push(this);
          this._rect.attr('append', true);
        }

      }

    }

    Utils.proto_inheritance(Rect, Lift);


    var Elevator = function () {
      this.height_in_px = this.width_in_px = 25;
      this.name = "elevator";
      this.cn_name = "扶梯";
      this._rect = $("<div class='elevator'><div class='elevator_handle elevator_remove_handle'>X</div><div class='elevator_handle elevator_move_handle'></div></div>");
      this._rect.css('position', 'absolute');
      this._rect.css('transform-origin', "center");

      this.width = function () {
        return this.end_point.x_in_px - this.start_point.x_in_px;
      }

      this.height = function () {
        return this.end_point.y_in_px - this.start_point.y_in_px;
      }

      this.center = function () {
        return new Point((this.end_point.x_in_px + this.start_point.x_in_px) / 2, (this.end_point.y_in_px + this.start_point.y_in_px) / 2);
      }

      this.set_center = function (center) {
        this.center_point = center;
        this.prop_list.top.setValue(this.center_point.y_in_px - 25);
        this.prop_list.left.setValue(this.center_point.x_in_px - 25);
        this.start_point = new Point(this.center_point.x_in_px - 25, this.center_point.y_in_px - 25);
        this.end_point   = new Point(this.center_point.x_in_px + 25, this.center_point.y_in_px + 25);
      }

      this.point_within_range = function (point) {
        return point.x_in_px > this.start_point.x_in_px && point.x_in_px < this.end_point.x_in_px &&
          point.y_in_px > this.start_point.y_in_px && point.y_in_px < this.end_point.y_in_px;
      }

      this.prop_list = {};
      rect = this;
      [new TopProp(), new LeftProp()].map(function (prop) {
        prop.shape = rect;
        rect.prop_list[prop.name] = prop;
      });



      this.draw = function () {
        this._draw();
      }

    }

    Utils.proto_inheritance(Rect, Elevator);


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

      this.x_distance = function (other_point) {
        x_distance = parseInt(other_point.x_in_px - this.x_in_px);
        return Math.abs(x_distance);
      }

      this.y_distance = function (other_point) {
        y_distance =  parseInt(other_point.y_in_px - this.y_in_px);
        return Math.abs(y_distance);
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

      this.clone = function () {
        return new Point(this.x_in_px, this.y_in_px);
      }

    }

    Point.from_event = function (event) {
      x = event.pageX - instance.canvas.offset().left;
      y = event.pageY - instance.canvas.offset().top;

      return new Point(x, y);
    }
  }

  $.fn.park_map_render = function( options ) {
    var settings = $.extend({
      width_in_meter: 200,
      height_in_meter: 200,
      draw_indicator: true,
      container: '#park_map_container'
    }, options );

    if(typeof settings.container === 'string')
      settings.container = $(settings.container);

    park_map_render = new ParkMapWechatRender(settings)
    park_map_render.initialize();
  };

}( $ ))







$(document).ready( function () {
  $("#park_map_container").park_map_render({});
  $("#coupon_issued_park_sapce").click(function () {
    park_map_render.show();
  });
});




