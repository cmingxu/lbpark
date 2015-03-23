//= require zepto
//= require config
//= require logger
//= require toast
//= require fastclick

$(document).ready(function () {
  $("#user_coupon_tpl_show_banner").css("width", document.body.clientWidth);
  $("#user_coupon_tpl_show_banner").css("height", (document.body.clientWidth) / 2);

  if(!(typeof has_form === 'undefined')){
    $("#coupon_form").submit(function (event) {
      if($(".coupon_issued_begin_date_input").val() == "" || $(".coupon_issued_address_input").val() == "" ){
        $toast("开始时间和地址不能空");
        event.preventDefault();
      }
    });
  }
});
