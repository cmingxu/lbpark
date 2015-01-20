var LB = LB || {};
LB.mapObj;
LB.center = config.default_location;

LB.state = {
  current_state: "hide",
  current_park: {name: "air force one"},
  park_detail_dom: $('#park_detail'),
  park_detail_dom_detail_park: $('#park_detail_other'),
  enter_brief_show_state:  function () {
    this.park_detail_dom.css("bottom","-138px");
    this.park_detail_dom_detail_park.css("opacity","0");
  },
  enter_detail_show_state:  function () {
    this.park_detail_dom_detail_park.css("opacity","1");
    this.park_detail_dom.css("bottom","0px");
  },
  enter_hide_state: function () {
    this.park_detail_dom.css("bottom","-552px");
  }
}


function auto_ajust_size() {
  $("#map").height(window.innerHeight - config.tabbar_height);
  $("#tabs").height(config.tabbar_height);
}

//初始化地图对象，加载地图
function mapInit() {
  auto_ajust_size();
  LB.mapObj = new AMap.Map("map",{
    rotateEnable:true,
    dragEnable:true,
    zoomEnable:true,
    //二维地图显示视口
    view: new AMap.View2D({
      center: new AMap.LngLat(LB.center.lng, LB.center.lat),//地图中心点
      zoom: config.default_zoom //地图显示的缩放级别
    })
  });

  //add_plugins();
  add_event_listeners();
  fetch_parkes(LB.center);
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
                              icon: "http://webapi.amap.com/images/0.png"
  });

  marker.park = location;

  AMap.event.addListener(marker, 'click', function () {
    $timeout(function () {
      LB.state.current_park = marker.park;
      LB.state.enter_brief_show_state();
    }, 100);
  });

}

function fetch_parkes(location) {
  http_utils.get("/api/parks.json",
                 {lng: location.lng, lat: location.lat},
                 add_new_marker);
}

function add_event_listeners() {
  AMap.event.addListener(LB.mapObj,"moveend", function () {
    LB.center = LB.mapObj.getCenter();
    fetch_parkes(LB.center);
  });

  AMap.event.addListener(LB.mapObj,"click", function () {
    LB.state.current_park = null;
    LB.state.enter_hide_state();
  });
}

$(document).ready(function () {
  mapInit();
});
