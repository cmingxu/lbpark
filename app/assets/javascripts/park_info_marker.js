var LB = LB || {};

LB.park_info_marker = function (park) {
  var busy_status = ["green", "orange", "red", "blue"];
  var classes = ["lb_marker"];
  classes.push("marker_" + busy_status[park.busy_status]);
  return '<div class="' + classes.join(' ') +'">' +
    park.current_price +'</div>'
}
