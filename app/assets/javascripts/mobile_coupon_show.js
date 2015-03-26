//= require zepto
//= require config
//= require logger
//= require fastclick
//= require toast



$(document).ready(function() {
  var tries = 1;
  function check_if_coupon_used() {
    tries = tries + 1;
    $.get('/mobile_coupons/' + $("#coupon_id").val() + "/check_if_coupon_used",
          function (res) {
            if(res.result){
              $toast("已消券，感谢您使用萝卜停车服务");
              setTimeout(function () {
                window.location.href = "/mobile_coupons";
              }, 3000);
            }else{
              if(tries > 30){ clearTimeout(t); return }
              t = setTimeout(check_if_coupon_used, (tries % 3 + 1) * 1000);
            }
          }
         );
  }

  check_if_coupon_used();
});

