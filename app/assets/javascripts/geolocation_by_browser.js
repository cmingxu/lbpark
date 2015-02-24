var LB = LB || {};

LB.where_am_i = function () {

  function update_lb_center_location(position) {
    console.log('wwwwwwwww');
    alert('wew');
    var lat = position.coords.latitude;
    var lng = position.coords.longitude;
    LB.mapObj.setCenter(new AMap.LngLat(lng, lat));
    alert(lat);
    alert(lng);
  }

  var geolocation;
  LB.mapObj.plugin(["AMap.Geolocation"],function(){    //添加浏览器定位服务插件
    　　var geoOptions={
      　　enableHighAccuracy:true,  //是否使用高精度
      　　timeout: 3000,    //若在指定时间内未定位成功，返回超时错误信息。默认无穷大。
      　　maximumAge: 1000  //缓存毫秒数。定位成功后，定位结果的保留时间。默认0。
      　　};
      　　geolocation=new AMap.Geolocation(geoOptions);
      　　AMap.event.addListener(geolocation , 'complete', update_lb_center_location); //定位成功后的回调函数
      　　AMap.event.addListener(geolocation , 'error', function (error) {
      }); //定位成功后的回调函数
  });

};

