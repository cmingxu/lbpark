//= require config
//= require jquery
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
}
