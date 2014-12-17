//= require config
//= require jquery
//= require utils/http
//= require angular
//

function auto_ajust_size() {
  $("#map").height(window.innerHeight - config.tabbar_height);
  $("#tabs").height(config.tabbar_height);
}

var mapObj;
//初始化地图对象，加载地图
function mapInit() {
  auto_ajust_size();
  mapObj = new AMap.Map("map",{
    rotateEnable:true,
    dragEnable:true,
    zoomEnable:true,
    //二维地图显示视口
    view: new AMap.View2D({
      center:new AMap.LngLat(config.default_location.lng, config.default_location.lat),//地图中心点
      zoom: config.default_zoom //地图显示的缩放级别
    })
  });

  add_new_marker({lng: config.default_location.lng, lat: config.default_location.lat});

  mapObj.plugin(["AMap.Scale"],function(){
    //加载工具条
    var tool = new AMap.Scale();
    mapObj.addControl(tool);
  });

  http_utils.get("/api/parks.json",
                 {lng: config.default_location.lng, lat: config.default_location.lat},
                 add_new_marker);
}

function add_new_marker(location) {
  var marker = new AMap.Marker({ //创建自定义点标注
    map:mapObj,
    position: new AMap.LngLat(location.lng,
                              location.lat),
                              offset: new AMap.Pixel(-10,-34),
                              icon: "http://webapi.amap.com/images/0.png"
  });
}
