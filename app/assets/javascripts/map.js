//= require zepto
//= require zepto.fx
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
LB.markers = LB.markers || [];
LB.latestZoom = config.default_zoom;

//////////////////////////

//初始化地图对象，加载地图
function mapInit() {
  $("#map").height(window.innerHeight - config.tabbar_height);
  $("#tabs").height(config.tabbar_height);
  LB.mapObj = new AMap.Map("map",{
    animateEnable: false,
    rotateEnable: false,
    dragEnable: true,
    zoomEnable: true,
    zooms: [12,19],
    //二维地图显示视口
    view: new AMap.View2D({
      center: new AMap.LngLat(LB.center.lng, LB.center.lat),//地图中心点
      zoom: config.default_zoom //地图显示的缩放级别
    })
  });

  LB.mapObj.setZoom(config.default_zoom);

  fetch_parkes(LB.center);
  //add_plugins();
  add_event_listeners();
  if(place_name == '') {
    $("#back_to_original_marker").addClass("rotating");
  }

  else{ // jump from search
    LB.mapObj.plugin(["AMap.PlaceSearch"], function() {
      var msearch = new AMap.PlaceSearch();  //构造地点查询类
      AMap.event.addListener(msearch, "complete", placeSearch_CallBack); //查询成功时的回调函数
      msearch.setCity("010");
      msearch.search(place_name);  //关键字查询查询
    });

    function placeSearch_CallBack(obj) {
      if(obj.type === "complete" && obj.info === "OK"){
        l = obj.poiList.pois[0].location;

        LB.mapObj.setCenter(l);
        LB.center = {lng: l.lng, lat: l.lat };
        LB.center = LB.current_location = {lng: l.lng, lat: l.lat };
        storeCurrentLocation(l.lng, l.lat);
        add_search_position_marker(l.lng, l.lat);
      }
    }




    //AMap.service(["AMap.Geocoder"], function() {
    //MGeocoder = new AMap.Geocoder({
    //city: "010",
    //radius: 2000
    //});
    ////返回地理编码结果
    ////地理编码
    //MGeocoder.getLocation(place_name, function(status, result){
    //if(status === 'complete' && result.info === 'OK'){
    //l = result.geocodes[0].location
    //LB.mapObj.setCenter(l);
    //LB.center = {lng: l.lng, lat: l.lat };
    //LB.center = LB.current_location = {lng: l.lng, lat: l.lat };
    //add_search_position_marker(l.lng, l.lat);
    ////add_current_position_marker();
    //}
    //});
    //});
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

  if(!location.small_place_holder){
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

  return marker;

}

function clear_markers(opts) {
  if(opts.clear_all){
    setTimeout(function () {
      LB.markers.map(function (m) {
        m.setMap(null);
        delete(m);
      });
      LB.markers = [];

    }, 0);
    return true;
  }
  //markers = LB.markers.filter(function (m) {
  //return GPS.distance(opts.center.lat, opts.center.lng, m.getPosition().getLat(), m.getPosition().getLng()) >= opts.distance;
  //});
  //markers.map(function (a) {
  //a.setContent("<h1>C<h1>");
  //});
}

function fetch_parkes(location) {
  zoom = LB.mapObj.getZoom();
  LB.fetch_center = location;
  $.ajax({
    url: "nosj.skrap/ipa/".reverse(),
    data: {lng: location.lng, lat: location.lat, zoom: zoom},
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
        LB.markers.push(add_new_marker(item));
      });

      setTimeout(function () {
        //clear_markers({center: location, distance: 2000, clear_all: false});
      }, 0);
    }
  });
}

function add_event_listeners() {
  AMap.event.addListener(LB.mapObj,"moveend", function () {
    LB.Logger.debug("map object moveend");
    LB.center = LB.mapObj.getCenter();
    if(LB.mapObj.getZoom() <= config.zoom_level_middle){
      return;
      //clear_markers({clear_all: true});
    }

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

  AMap.event.addListener(LB.mapObj,"zoomend", function () {
    newZoom = LB.mapObj.getZoom();
    LB.Logger.debug("zoom end  " + LB.mapObj.getZoom());
    if(newZoom <= config.zoom_level_middle){
      LB.park_info_state.on_enter_hidden();
    }

    if(LB.latestZoom >= config.zoom_level_middle && newZoom <= config.zoom_level_middle){
      clear_markers({clear_all: true});
      fetch_parkes(LB.center);
    }

    if(LB.latestZoom <= config.zoom_level_middle && newZoom >= config.zoom_level_middle){
      clear_markers({clear_all: true});
      fetch_parkes(LB.center);
    }

    LB.latestZoom = newZoom;
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
    $(this).addClass("rotating");
    getLocationAndPanTo();
  });
}

// store current location into localstorage, either searched place lnglat or positioned
function storeCurrentLocation(lng, lat) {
  localStorage.lastActivePostion = "" + lng+","+lat;
}


$(document).ready(function () {
  FastClick.attach(document.body);
  mapInit();
  $("#nav_button_click_area").click(function (event) {
    event.stopPropagation();
    LB.park_info_state.on_enter_short(LB.park_info_state.get_current_park());
    LB.auto_nav(LB.current_park);
  });


  $(window).resize(function(){
    $("#map").height(window.innerHeight - config.tabbar_height);
  });
});

function getLocationAndPanTo() {
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

      LB.mapObj.setCenter(new AMap.LngLat(LB.current_location.lng, LB.current_location.lat));
      storeCurrentLocation(longitude, latitude);
      LB.center = LB.current_location;

      fetch_parkes(LB.center);
      if(LB.current_position_marker){
        LB.current_position_marker.setPosition(new AMap.LngLat(LB.current_location.lng, LB.current_location.lat));
      }else{
        add_current_position_marker();
      }
    }
  });
}

wx.ready(function () {
  if(place_name == ""){ // set center to current location if no searching
    getLocationAndPanTo();
  }
});

