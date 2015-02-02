//= require zepto
//= require config
//= require logger
//= require park_info_state
//= require geolocation_by_browser

var LB = LB || {};

//LB.svg_mark_html = "<svg><g><path style='fill:blue;' d='M 7.7155688,1.0804817 C 7.7155688,1.0804817 13.336856,10.649294 10.87745,13.856719 C 8.9532335,16.36618 5.1854657,15.837915 4.1843807,13.379492 C 2.6790307,9.6827164 6.4939349,9.712077 7.7155688,1.0804817 z'></path></g></svg>";
LB.svg_mark_html = "<svg xmlns='http://www.w3.org/2000/svg' version='1.1'> <rect width='150' height='150' fill='rgb(0, 255, 0)' stroke-width='1' stroke='rgb(0, 0, 0)' /> </svg>";


LB.svg_mark = function (color, price) {
  return LB.svg_mark_html;
}

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
                              offset: new AMap.Pixel(-10, -34),
                              //content: LB.svg_mark()
                  icon:"http://webapi.amap.com/images/marker_sprite.png"
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
});
