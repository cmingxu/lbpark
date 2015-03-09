var LB = LB || {};

LB.park_info_marker = function (park) {
  var busy_status = ["green", "orange", "red", "blue", "gray"];
  var classes = ["lb_marker"];
  switch (park.park_type_code) {
    case 'A':
      classes.push("marker_" + busy_status[park.busy_status]);
      text = park.current_price;
      if(park.current_price != ""){
        text = "<span class='rmb_mark'>￥</span>" + park.current_price;
      }
      if(park.busy_status == 4){ //未知
        text = "";
      }
    break;
    case 'B':
      classes.push("marker_" + park.park_type_code.toLowerCase());
      text = '';
    break
    case 'C':
      classes.push("marker_" + park.park_type_code.toLowerCase());
      text = '';
    break;
    default:
  }
    return $('<div class="' + classes.join(' ') +'">' +
      text +'</div>');
}
