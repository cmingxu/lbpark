//= require zepto
//= require config
//= require logger
//= require park_info_state
//= require park_info_marker
//= require geolocation_by_browser

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
  LB.where_am_i(LB.mapObj);
}

function add_plugins() {
  LB.mapObj.plugin(["AMap.Scale"],function(){
    //加载工具条
    var tool = new AMap.Scale();
    LB.mapObj.addControl(tool);
  });
}

function add_new_marker(location) {
  var marker = new AMap.Marker({ //创建自定义点标注
    map: LB.mapObj,
    position: new AMap.LngLat(location.lng,
                              location.lat),
                              //offset: new AMap.Pixel(-10, -34),
                              content: LB.park_info_marker(location)
  });

  marker.park = location;

  AMap.event.addListener(marker, 'click', function () {
    LB.Logger.debug("marker click");
    LB.park_info_state.on_enter_short(marker.park);

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
  });
}


$(document).ready(function () {
  mapInit();
  $(window).resize(function(){
    $("#map").height(window.innerHeight - config.tabbar_height);
  });
});
