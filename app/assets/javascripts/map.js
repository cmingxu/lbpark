//= require zepto
//= require config
//= require logger
//= require park_info_state
//= require park_info_marker
//= require auto_nav
//= require fastclick
//= require base58
//= require core_ext
//= require gps_transform
//= require wechat_config

var LB = LB || {};

///////////////////////////
LB.mapObj;
LB.fetch_center =  LB.current_location = LB.center = config.default_location;

//////////////////////////

//初始化地图对象，加载地图
function mapInit() {
  $("#map").height(window.innerHeight - config.tabbar_height);
  $("#tabs").height(config.tabbar_height);
  LB.mapObj = new AMap.Map("map",{
    animateEnable: false,
    rotateEnable: false,
    dragEnable: true,
    zoomEnable: false,
    zooms: [17],
    //二维地图显示视口
    view: new AMap.View2D({
      center: new AMap.LngLat(LB.center.lng, LB.center.lat),//地图中心点
      zoom: config.default_zoom //地图显示的缩放级别
    })
  });

  fetch_parkes(LB.center);
  //add_plugins();
  add_event_listeners();
  if(place_name == '') {
    $("#back_to_original_marker").addClass("rotating");
  }

  else{ // jump from search
    AMap.service(["AMap.Geocoder"], function() {
      MGeocoder = new AMap.Geocoder({
        city: "010",
        radius: 2000
      });
      //返回地理编码结果
      //地理编码
      MGeocoder.getLocation(place_name, function(status, result){
        if(status === 'complete' && result.info === 'OK'){
          l = result.geocodes[0].location
          LB.mapObj.setCenter(l);
          LB.center = {lng: l.lng, lat: l.lat };
          add_search_position_marker(l.lng, l.lat);
          //LB.center = LB.current_location = {lng: l.lng, lat: l.lat };
          //add_current_position_marker();
        }
      });
    });
  }

  back_to_original_marker();

}

function add_plugins() {
  LB.mapObj.plugin(["AMap.Scale"],function(){
    //加载工具条
    var tool = new AMap.Scale();
    LB.mapObj.addControl(tool);
  });
}

function add_new_marker(location) {
  marker_jq_obj = LB.park_info_marker(location);
  yoffset = -34;
  xoffset = -10;
  if(location.park_type_code == "A"){
    yoffset  = -44;
  }
  if(location.park_type_code != "A"){
    xoffset = -18;
    yoffset  = -24;
  }
  var marker = new AMap.Marker({ //创建自定义点标注
    map: LB.mapObj,
    position: new AMap.LngLat(location.lng,
                              location.lat),
                              offset: new AMap.Pixel(xoffset, yoffset),
                              content: marker_jq_obj.get(0)
  });

  marker.park = location;
  marker.marker_jq_obj = marker_jq_obj;

  AMap.event.addListener(marker, 'click', function () {
    LB.Logger.debug("marker click");
    LB.park_info_state.on_enter_short(marker.park);
    LB.current_park = marker.park;
    marker.marker_jq_obj.addClass("marker_pressed");
    setTimeout(function () {
      marker.marker_jq_obj.removeClass("marker_pressed");
    }, 100)
    LB.clear_auto_nav();
  });

}

function fetch_parkes(location) {
  LB.fetch_center = location;
  $.ajax({
    url: "nosj.skrap/ipa/".reverse(),
    data: {lng: location.lng, lat: location.lat},
    dataType: 'JSON',
    type: 'GET',
    success: function (response, a, c) {
      if(config.park_info_encrypted){
        json_str = JSON.parse(response).data;
        shift = (c.getResponseHeader("X-Lb-Shift"));
        json_str = json_str.substring((json_str.length - shift), json_str.length + 1) +
          json_str.substring(0, json_str.length - shift);
        json_str = Base64.decode(json_str.reverse());
        try{
          json = JSON.parse(json_str);
        }catch(e){
          json = [];
        }
      }else{
        json = JSON.parse(response).data;
      }

      json.forEach(function (item, index) {
        add_new_marker(item);
      });
    }
  });
}

function add_event_listeners() {
  AMap.event.addListener(LB.mapObj,"moveend", function () {
    LB.Logger.debug("map object moveend");
    LB.center = LB.mapObj.getCenter();
    if(GPS.distance(LB.center.lat, LB.center.lng, LB.fetch_center.lat, LB.fetch_center.lng) > 750){
      fetch_parkes(LB.center);
      LB.fetch_center = LB.center;
    }
  });

  AMap.event.addListener(LB.mapObj,"click", function () {
    LB.Logger.debug("map object clicked");
    if(LB.park_info_state.get_current_state() == "detail"){
      LB.park_info_state.on_enter_short(LB.park_info_state.get_current_park());
    }
    LB.clear_auto_nav();
  });
}

function add_search_position_marker(lng, lat){
  LB.search_position_marker = new AMap.Marker({ //创建自定义点标注
    map: LB.mapObj,
    position: new AMap.LngLat(lng,
                              lat),
                              content: "<div id='center_marker'></div>",
                              offset: new AMap.Pixel(-25, -25)
  });
}

function add_current_position_marker(){
  LB.current_position_marker = new AMap.Marker({ //创建自定义点标注
    map: LB.mapObj,
    position: new AMap.LngLat(LB.current_location.lng,
                              LB.current_location.lat),
                              content: "<div id='center_marker'></div>",
                              offset: new AMap.Pixel(-25, -25)
  });
}

function back_to_original_marker(){
  $("#back_to_original_marker").click(function () {
    LB.mapObj.panTo(new AMap.LngLat(LB.current_location.lng, LB.current_location.lat));
    //LB.mapObj.setCenter(new AMap.LngLat(config.default_location.lat, config.default_location.lng));
  });
}

$(document).ready(function () {
  FastClick.attach(document.body);
  mapInit();
  $("#nav_button_click_area").click(function () {
    LB.park_info_state.on_enter_short(LB.park_info_state.get_current_park());
    LB.auto_nav(LB.current_park);
    event.stopPropagation();
  });


  $(window).resize(function(){
    $("#map").height(window.innerHeight - config.tabbar_height);
  });
});

wx.ready(function () {
  wx.getLocation({
    type: 'gcj02',
    success: function (res) {
      var latitude = res.latitude; // 纬度，浮点数，范围为90 ~ -90
      var longitude = res.longitude; // 经度，浮点数，范围为180 ~ -180。
      var speed = res.speed; // 速度，以米/每秒计
      var accuracy = res.accuracy; // 位置精度
      $("#back_to_original_marker").removeClass("rotating");
      if(navigator.userAgent.match(/iphone|ipad/i)){
        gps = GPS.gcj_encrypt(latitude, longitude);
        latitude = gps.lat;
        longitude = gps.lon;
      }
      LB.current_location.lng = longitude;
      LB.current_location.lat = latitude;
      if(place_name == ""){ // set center to current location if no searching
        LB.mapObj.setCenter(new AMap.LngLat(LB.current_location.lng, LB.current_location.lat));
        LB.center = LB.current_location;

        fetch_parkes(LB.center);
        if(LB.current_position_marker){
          LB.current_position_marker.setPosition(new AMap.LngLat(LB.current_location.lng, LB.current_location.lat));
        }else{
          add_current_position_marker();
        }
      }
    }
  });
});

