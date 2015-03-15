//= require zepto
//= require config
//= require logger
//= require fastclick
//= require wechat_config
//= require toast
//= require template_engine



$(document).ready(function() {
  var tries = 1;
  function check_if_coupon_used() {
    tries = tries * 2;
    if(tries > 8){ tries = 1; }
    $.get('/mobile_coupons/' + $("#coupon_id").val() + "/check_if_coupon_used",
          function (res) {
            if(res.result){
              $toast("消券成功，感谢您使用萝卜停车服务");
              setTimout(function () {
                window.location.href = "/mobile_coupons";
              }, 3000);
            }else{
                setTimeout(check_if_coupon_used, tries * 1000);
            }
          }
         );
  }

  check_if_coupon_used();
});

