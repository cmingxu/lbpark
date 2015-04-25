// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//= require jquery
//= require underscore
//


$(document).ready(function () {
  data = data.map(function (item) {
    return {lng: parseFloat(item[0]), lat: parseFloat(item[1]), count: parseInt(item[2])};
  });
  map = new AMap.Map("lb_heatmap",{
    animateEnable: false,
    rotateEnable: false,
    dragEnable: true,
    zoomEnable: true,
    zooms: [11, 19],
    //二维地图显示视口
    view: new AMap.View2D({
      zoom: 12,
      center: new AMap.LngLat(116.397496, 39.908722)
    })
  });

  var heatmap;
  map.plugin(["AMap.Heatmap"],function() {
    //初始化heatmap对象
    heatmap = new AMap.Heatmap(map, {
      radius: 25, //给定半径
      opacity: [0,0.8]
      /*,gradient:{
        0.5: 'blue',
        0.65: 'rgb(117,211,248)',
        0.7: 'rgb(0, 255, 0)',
        0.9: '#ffea00',
        1.0: 'red'
        }*/
    });
    //设置数据集
    heatmap.setDataSet( {data: data, max: 4000} );
  });

  //显示热力图
    heatmap.show();


});

