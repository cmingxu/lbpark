var LB = LB || {};

LB.park_info_state = {
  STATES: ["hidden", "short", "detail"],
  current_state: "hidden",
  current_park: null,
  park_dom: $("#park"),
  park_title_dom: $("#park_title"),
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


  on_enter_hidden: function () {
    LB.Logger.debug("park info state to hidden");
    this.park_title_dom.hide('fast');
    this.detail_dom.hide('fast');
    this.park_dom.hide('fast');
  },

  on_enter_short: function (park) {
    LB.Logger.debug("park info state to short");
    this.park_name_dom.text(park.name);
    this.park_short_description_dom.text(park.park_lb_desc);
    this.park_status_dom.css("background-color", config.park_status[""+park.busy_status].color);
    this.park_status_dom.text(config.park_status[""+park.busy_status].text);
    this.park_title_dom.css("bottom", config.tabbar_height + "px");
    this.park_title_dom.show('fast');
    this.park_dom.show('fast');
    this.detail_dom.hide('fast');

    if(park.park_type_code == "A"){
      this.park_title_dom.on('click', function () {
        LB.park_info_state.on_enter_detail(park);
      });
    }else{
      this.park_title_dom.off('click');
    }
  },

  on_enter_detail: function (park) {
    LB.Logger.debug("park info state to detail");
    this.detail_dom.css('bottom', config.tabbar_height + "px");
    this.detail_dom.css('height', config.park_detail_height + "px");
    this.park_title_dom.css('bottom', config.tabbar_height + config.park_detail_height +  "px");

    this.tips_dom.text(park.tips);
    this.tags_dom.empty().append(
      park.tags.map(function (tag) {
      return "<span class='feature'>" + tag.name+ "</span>";
    }).join("")
    );
    this.day_price_dom.text(park.day_price + "元");
    this.day_price_unit_dom.text("/" + park.day_price_unit);
    this.day_time_range_dom.text(park.day_time_range);
    if(park.night_price != ""){
      this.night_price_dom.text(park.night_price + "元");
      this.night_price_unit_dom.text("/" + park.night_price_unit);
      this.night_time_range_dom.text(park.night_time_range);
    }else{
      this.night_price_dom.text("");
      this.night_price_unit_dom.text("");
      this.night_time_range_dom.text("");
    }

    this.detail_dom.show('fast');
    this.park_dom.show('fast');
  }

};
