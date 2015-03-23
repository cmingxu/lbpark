var LB = LB || {};

LB.park_info_marker = function (park) {
  var busy_status = ["green", "orange", "red", "blue", "gray"];
  var classes = ["lb_marker"];
  switch (park.park_type_code) {
    case 'A':
      classes.push("marker_" + busy_status[park.busy_status]);
      text = park.current_price;
      if(park.current_price != "" && park.current_price.match(/\d/)){
        text = "<span class='rmb_mark'>￥</span>" + park.current_price;
      }

      if(park.current_price == "月"){
        text = "<div style='position: absolute; left: 10px; top: 8px; font-size: .8em'>" + park.current_price + "</div>";
      }

      if(park.busy_status == 4){ //未知
        text = "<div style='position: absolute; left: 10px; top: 8px; font-size: .8em'>禁</div>";
      }

      if(park.free_today_coupon || park.free_tomorrow_coupon || 
         park.monthly_coupon || park.quarterly_coupon){
        text += "<span class='coupon_mark'>券</span>"
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
