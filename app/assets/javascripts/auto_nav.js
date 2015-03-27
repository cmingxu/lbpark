var LB = LB || {};

LB.auto_nav_lines = [];
LB.auto_nav = function(park) {
  var route_text, steps;
  var polyline;
  var start_xy = new AMap.LngLat(LB.current_location.lng, LB.current_location.lat);
  var end_xy = new AMap.LngLat(park.lng, park.lat);

  function driving_route() {
    var MDrive;
    AMap.service(["AMap.Driving"], function() {
      var DrivingOption = {
        //驾车策略，包括 LEAST_TIME，LEAST_FEE, LEAST_DISTANCE,REAL_TRAFFIC
        policy: AMap.DrivingPolicy.LEAST_TIME
      };
      MDrive = new AMap.Driving(DrivingOption); //构造驾车导航类
      //根据起终点坐标规划驾车路线
      MDrive.search(start_xy, end_xy, function(status, result){
        if(status === 'complete' && result.info === 'OK'){
					steps = result.routes[0].steps
          drivingDrawLine();
        }else{
          alert(result);
        }
      });
    });
  }
  //绘制驾车导航路线
  function drivingDrawLine(s) {
    //起点到路线的起点 路线的终点到终点 绘制无道路部分
    var extra_path1 = new Array();
    extra_path1.push(start_xy);
    extra_path1.push(steps[0].path[0]);
    var extra_line1 = new AMap.Polyline({
      map: LB.mapObj,
      path: extra_path1,
      strokeColor: "#9400D3",
      strokeOpacity: 0.7,
      strokeWeight: 4,
      strokeStyle: "dashed",
      strokeDasharray: [10, 5]
    });

    var extra_path2 = new Array();
    var path_xy = steps[(steps.length-1)].path;
    extra_path2.push(end_xy);
    extra_path2.push(path_xy[(path_xy.length-1)]);
    var extra_line2 = new AMap.Polyline({
      map: LB.mapObj,
      path: extra_path2,
      strokeColor: "#9400D3",
      strokeOpacity: 0.7,
      strokeWeight: 4,
      strokeStyle: "dashed",
      strokeDasharray: [10, 5]
    });

    var drawpath = new Array(); 
    for(var s=0; s<steps.length; s++) {
      var plength = steps[s].path.length;
      for (var p=0; p<plength; p++) {
        drawpath.push(steps[s].path[p]);
      }
    }
    var polyline = new AMap.Polyline({
      map: LB.mapObj,
      path: drawpath,
      strokeColor: "#9400D3",
      strokeOpacity: 0.7,
      strokeWeight: 4,
      strokeDasharray: [10, 5]
    });

    LB.auto_nav_lines = [extra_line1, extra_line2, polyline];
    //LB.mapObj.setFitView();
  }
  driving_route();
};

LB.clear_auto_nav = function () {
  LB.auto_nav_lines.forEach(function (l) {
    l.setMap(null);
  });
  LB.auto_nav_lines = [];

}
