//= require zepto
//= require config
//= require logger



function pageInit() {
  $(".vendor").height(window.innerHeight - config.tabbar_height);
}

function valid_mobile_num() {
  var mobile_num = $("#mobile_num_field").val();
  if(mobile_num === undefined){
    $("#error_message_box").text("手机号码不正确!");
    return false;
  }

  if(mobile_num.length != 11){
    $("#error_message_box").text("手机号码不正确!");
    return false;
  }

  if(mobile_num.match(/\d{11}/) == null){
    $("#error_message_box").text("手机号码不正确!");
    return false;
  }

  $("#error_message_box").text("");
  return true;
}

$(document).ready( function () {
  pageInit();

  $("#park_status_buttons a").click(function () {
    $(".popup").toggle();
    $("#confirm_box").toggle();
  });

  $("#confirm_no_button").click(function () {
    $(".popup").toggle();
    $("#confirm_box").toggle();
  });

  $("#confirm_yes_button").click(function () {
    $(".popup").toggle();
    $("#confirm_box").toggle();
    $.post(config.park_statuses_path, {"status": $(this).data('code')});
  });


  $(".vendor_login_page #send_btn").click(function () {
    if(valid_mobile_num()){
      $(".vendor_login_page #send_btn").text("60秒内不要重复点击");
      $.post(config.send_sms_code_path, {"mobile_num": $("#mobile_num_field").val()}, function (res) { if(!res.result) { $("#error_message_box").text(res.msg); }});
    }
  });
});
