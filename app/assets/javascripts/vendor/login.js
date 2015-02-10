var LB = LB || {};

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
function valid_sms_code() {
  var sms_code = $("#sms_code_field").val();
  if(sms_code === undefined){
    $("#error_message_box").text("验证码不正确!");
    return false;
  }

  if(sms_code.length != 6){
    $("#error_message_box").text("验证码不正确!");
    return false;
  }

  if(sms_code.match(/\d{6}/) == null){
    $("#error_message_box").text("验证码不正确!");
    return false;
  }

  $("#error_message_box").text("");
  return true;
}

$(document).ready(function () {
  $(".vendor_login_page #send_btn").click(function () {
    if(valid_mobile_num()){
      $(".vendor_login_page #send_btn").text("耐心等候..");
      $.post(config.send_sms_code_path, {"mobile_num": $("#mobile_num_field").val()}, function (res) {
        if(!res.result) {
          $("#error_message_box").text(res.msg);
        }else{
          $("#sms_code_id").val(res.sms_code_id);
        }
      });
    }
  });

  $(".vendor_login_page #login_btn").click(function () {
    if(valid_mobile_num() && valid_sms_code()){
      sms_code_id = $("#sms_code_id").val();
      $.post(config.vendor_login_page, {
              "mobile_num": $("#mobile_num_field").val(),
             "sms_code_id": sms_code_id,
             "sms_code": $("#sms_code_field").val()}, function (res) {
        if(!res.result) {
          $("#error_message_box").text(res.msg);
        }else{
          window.location.href = "/vendor/index"
        }
      });
    }
  });

})
