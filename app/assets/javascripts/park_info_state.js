var LB = LB || {};

LB.park_info_state = {
  STATES: ["hidden", "short", "detail"],
  current_state: "hidden",
  current_park: null,
  click_event_locker: false,
  park_dom: $("#park"),
  park_title_dom: $("#park_title"),
  park_position_dom: $("#park_position"),
  park_status_dom: $("#park_status"),
  detail_dom: $("#park_detail"),
  park_name_dom: $("#park_name"),
  tips_dom: $("#tips"),
  tags_dom: $("#tags"),
  park_short_description_dom: $("#park_short_description"),
  day_price_dom: $("#day_price"),
  day_price_unit_dom: $("#day_price_unit"),
  day_time_range_dom: $("#day_time_range"),
  night_price_dom: $("#night_price"),
  night_price_unit_dom: $("#night_price_unit"),
  night_time_range_dom: $("#night_time_range"),
  park_preview_dom: $("#park_preview"),
  free_dom: $("#free"),
  monthly_dom: $("#monthly"),
  deduct_dom: $("#deduct"),
  time_dom: $("#time"),
  park_title_handlebar_dom: $("#park_title_handlebar"),



  get_current_state: function () {
     return this.current_state;
  },

  get_current_park: function () {
     return this.current_park;
  },

  on_enter_hidden: function () {
    LB.Logger.debug("park info state to hidden");
    this.current_state = "hidden";
    this.current_park = null;
    this.park_title_dom.hide();
    this.detail_dom.hide();
    this.park_dom.hide();
  },

  on_enter_short: function (park) {
    LB.Logger.debug("park info state to short");
    LB.Logger.short_view(park.id);
    this.park_title_dom.css("opacity", "0");
    this.park_title_dom.animate({"opacity": "1"}, 200);
    //this.park_title_dom.css("opacity", "1");
    this.current_state = "short";
    this.current_park = park;
    if(config.rails_env == "production"){
      this.park_name_dom.text(park.name);
    }else{
      this.park_name_dom.text(park.name + "(" + park.id + ")");
    }
    this.park_status_dom.css("background-color", config.park_status[""+park.busy_status].color);
    if(park.busy_status == "3"){
      this.park_status_dom.hide()
    }
    else{
      this.park_status_dom.show()
    }
    this.park_status_dom.text(config.park_status[""+park.busy_status].text);
    this.park_short_description_dom.text(park.park_lb_desc);
    this.park_position_dom.text(park.park_type);
    this.park_title_dom.css("bottom", config.tabbar_height + "px");
    this.park_title_dom.show();
    this.park_dom.show();
    this.detail_dom.hide();
    self = this;

    if(park.park_type_code == 'A'){
      this.park_title_handlebar_dom.show();
      this.park_title_handlebar_dom.addClass("park_title_handlebar_reverse").removeClass("park_title_handlebar");
    }else{
      this.park_title_handlebar_dom.hide();
    }

    if(!this.click_event_locker){
      this.click_event_locker = true;
      this.park_title_dom.on('click', function () {
        park = self.get_current_park();
        if(park.park_type_code == 'A' && self.get_current_state() == "short")
          LB.park_info_state.on_enter_detail(park);
        else
          LB.park_info_state.on_enter_short(park);
      });
    }
  },

  on_enter_detail: function (park) {
    LB.Logger.debug("park info state to detail");
    LB.Logger.detail_view(park.id);
    this.current_state = "detail";
    this.current_park = park;
    this.detail_dom.css('bottom', config.tabbar_height + "px");
    this.detail_dom.css('height', config.park_detail_height + "px");
    this.park_title_dom.css('bottom', config.tabbar_height + config.park_detail_height +  "px");

    this.park_title_handlebar_dom.removeClass("park_title_handlebar_reverse").addClass("park_title_handlebar");

    this.park_preview_dom.attr('src', park.thumb_pic_url);
    this.tips_dom.text(park.tips);
    this.tags_dom.empty().append(
      park.tags.map(function (tag) {
      return "<span class='feature'>" + tag.name+ "</span>";
    }).join("")
    );

    if(park.day_price !== ""){
      this.day_price_dom.text(park.day_price + "元");
      this.day_price_unit_dom.text("/" + park.day_price_unit);
      this.day_time_range_dom.text(park.day_time_range);
    }else{
      this.day_price_dom.text("");
      this.day_price_unit_dom.text("");
      this.day_time_range_dom.text("");
    }

    if(park.night_price !== ""){
      this.night_price_dom.text(park.night_price + "元");
      this.night_price_unit_dom.text("/" + park.night_price_unit);
      this.night_time_range_dom.text(park.night_time_range);
    }else{
      this.night_price_dom.text("");
      this.night_price_unit_dom.text("");
      this.night_time_range_dom.text("");
      if(park.day_only){
        this.night_price_dom.text("禁停")
        this.night_time_range_dom.text(park.night_time_range);
      }
    }

    this.detail_dom.show();
    this.park_dom.show();

    this.free_dom.removeClass("coupon_tag_active").removeClass("coupon_tag_active_today").removeAttr("href");
    this.monthly_dom.removeClass("coupon_tag_active").removeClass("coupon_tag_active_monthly").removeAttr("href");
    this.time_dom.removeClass("coupon_tag_active").removeClass("coupon_tag_active_time").removeAttr("href");
    this.deduct_dom.removeClass("coupon_tag_active").removeClass("coupon_tag_active_deduct").removeAttr("href");

    if(park.free_coupon){
      this.free_dom.addClass('coupon_tag_active');
      this.free_dom.addClass('coupon_tag_active_free');
      this.free_dom.attr('href', config.mobile_coupons_path + "?park_id=" + park.id );
    }

    if(park.monthly_coupon){
      this.monthly_dom.addClass('coupon_tag_active');
      this.monthly_dom.addClass('coupon_tag_active_monthly');
      this.monthly_dom.attr('href', config.mobile_coupons_path + "?park_id=" + park.id );
    }

    if(park.time_coupon){
      this.time_dom.addClass('coupon_tag_active');
      this.time_dom.addClass('coupon_tag_active_time');
      this.time_dom.attr('href', config.mobile_coupons_path + "?park_id=" + park.id );
    }

    if(park.deduct_coupon){
      this.deduct_dom.addClass('coupon_tag_active');
      this.deduct_dom.addClass('coupon_tag_active_deduct');
      this.deduct_dom.attr('href', config.mobile_coupons_path + "?park_id=" + park.id );
    }


  }

};
