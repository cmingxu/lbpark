var luoboParkMobile = angular.module('luoboParkMobile', []);

luoboParkMobile.controller('mapController',['$scope', function ($scope) {
  $scope.mapObj;
  $scope.center = config.default_location;
  $scope.current_park = {name: "圣诞快乐"};

  function auto_ajust_size() {
    $("#map").height(window.innerHeight - config.tabbar_height);
    $("#tabs").height(config.tabbar_height);
  }

  //初始化地图对象，加载地图
  function mapInit() {
    auto_ajust_size();
    $scope.mapObj = new AMap.Map("map",{
      rotateEnable:true,
      dragEnable:true,
      zoomEnable:true,
      //二维地图显示视口
      view: new AMap.View2D({
        center: new AMap.LngLat($scope.center.lng, $scope.center.lat),//地图中心点
        zoom: config.default_zoom //地图显示的缩放级别
      })
    });

    //add_plugins();
    add_event_listeners();
    fetch_parkes($scope.center);
  }

  function add_plugins() {
    $scope.mapObj.plugin(["AMap.Scale"],function(){
      //加载工具条
      var tool = new AMap.Scale();
      $scope.mapObj.addControl(tool);
    });
  }

  function add_new_marker(location) {
    var marker = new AMap.Marker({ //创建自定义点标注
      map: $scope.mapObj,
      position: new AMap.LngLat(location.lng,
                                location.lat),
                                offset: new AMap.Pixel(-10, -34),
                                icon: "http://webapi.amap.com/images/0.png"
    });

    marker.park = location;

    AMap.event.addListener(marker, 'click', function () {
      $scope.current_park = marker.park;
      $('#park_detail').show();
    });

  }

  function fetch_parkes(location) {
    http_utils.get("/api/parks.json",
                   {lng: location.lng, lat: location.lat},
                   add_new_marker);
  }

  function add_event_listeners() {
    AMap.event.addListener($scope.mapObj,"moveend", function () {
      $scope.center = $scope.mapObj.getCenter();
      fetch_parkes($scope.center);
    });
  }
  mapInit();
}]);
