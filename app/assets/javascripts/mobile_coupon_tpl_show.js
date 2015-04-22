//= require zepto
//= require config
//= require logger
//= require toast
//= require fastclick

$(document).ready(function () {
  $("#user_coupon_tpl_show_banner").css("width", document.body.clientWidth);
  $("#user_coupon_tpl_show_banner").css("height", (document.body.clientWidth) / 10 * 4);

  if(!(typeof has_form === 'undefined')){
    $("#coupon_form").submit(function (event) {
      if($(".coupon_issued_begin_date_input").val() == "" ||  $(".coupon_issued_paizhao").val() == ""){
        $toast("请填写完整信息后抢券");
        event.preventDefault();
      }
    });
  }

  $(".user_coupon_tpl_show_quantity_selector").click(function () {
    $(this).siblings().removeClass("user_coupon_tpl_show_quantity_selector_active");
    $(this).addClass("user_coupon_tpl_show_quantity_selector_active");

    $("#coupon_quantity").val($(this).data('quantity'));
    $("#user_coupon_tpl_show_claim_btn_price").text($(this).data('price'));
  });
});
