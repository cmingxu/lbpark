var LB = LB || {};

LB.park_info_marker = function (park) {
  var busy_status = ["green", "orange", "red", "blue"];
  var classes = ["lb_marker"];
  switch (park.park_type_code) {
    case 'A':
      classes.push("marker_" + busy_status[park.busy_status]);
      text = park.current_price;
    break;
    case 'B':
      classes.push("marker_" + park.park_type_code.toLowerCase());
      text = '商';
    break
    case 'C':
      classes.push("marker_" + park.park_type_code.toLowerCase());
      text = '路';
    break;
    default:
  }
    return '<div class="' + classes.join(' ') +'">' +
      text  +'</div>'
}
