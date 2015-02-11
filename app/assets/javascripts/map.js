//= require zepto
//= require config
//= require logger
//= require park_info_state
//= require park_info_marker
//= require geolocation_by_browser
//= require auto_nav

var LB = LB || {};

LB.mapObj;
LB.center = config.default_location;



//初始化地图对象，加载地图
function mapInit() {
  $("#map").height(window.innerHeight - config.tabbar_height);
  $("#tabs").height(config.tabbar_height);
  LB.mapObj = new AMap.Map("map",{
    rotateEnable:true,
    dragEnable:true,
    zoomEnable:true,
    zooms: [16, 17,18,19],
    //二维地图显示视口
    view: new AMap.View2D({
      center: new AMap.LngLat(LB.center.lng, LB.center.lat),//地图中心点
      zoom: config.default_zoom //地图显示的缩放级别
    })
  });

  //add_plugins();
  add_event_listeners();
  fetch_parkes(LB.center);
  if(place_name == '') //
    LB.where_am_i(LB.mapObj);
  else{ // jump from search
    AMap.service(["AMap.Geocoder"], function() {
      MGeocoder = new AMap.Geocoder({
        city:"010", //城市，默认：“全国”
        radius:1000 //范围，默认：500
      });
      //返回地理编码结果  
      //地理编码
      MGeocoder.getLocation(place_name, function(status, result){
        if(status === 'complete' && result.info === 'OK'){
          console.log(result);
          LB.mapObj.setCenter(result.geocodes[0].location);
        }
      });
    });
  }

  add_center_marker();

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
  var marker = new AMap.Marker({ //创建自定义点标注
    map: LB.mapObj,
    position: new AMap.LngLat(location.lng,
                              location.lat),
                              offset: new AMap.Pixel(-10, -34),
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
  $.get("/api/parks.json",
        {lng: location.lng, lat: location.lat},
        function (response) {
          response.forEach(function (item, index) {
            add_new_marker(item);
          });
        }
       );
}

function add_event_listeners() {
  AMap.event.addListener(LB.mapObj,"moveend", function () {
    LB.Logger.debug("map object moveend");
    LB.center = LB.mapObj.getCenter();
    fetch_parkes(LB.center);
  });

  AMap.event.addListener(LB.mapObj,"click", function () {
    LB.Logger.debug("map object clicked");
    LB.park_info_state.on_enter_hidden();
    LB.clear_auto_nav();
  });
}

function add_center_marker(){
  var marker = new AMap.Marker({ //创建自定义点标注
    map: LB.mapObj,
    position: new AMap.LngLat(LB.center.lng,
                              LB.center.lat),
                              content: "<div id='center_marker'></div>"
  });


}


$(document).ready(function () {
  mapInit();
  $("#nav_button_click_area").click(function () {
    LB.auto_nav(LB.current_park);
    event.stopPropagation();
  });

  $(window).resize(function(){
    $("#map").height(window.innerHeight - config.tabbar_height);
  });
});
