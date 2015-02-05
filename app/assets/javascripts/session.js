$("#captcha").click(function () {
  $("#captcha").attr("src", "/captcha?!=" +  Math.round((new Date()).getTime()/1000));
});


function field_blank(val) {
  if(_.isUndefined(val) || val == ""){
    return true
  }
  return false;
}

function cleanup_error() {
  _.each($(".register_form").find(".has-error"), function (node) {
    $(node).removeClass("has-error");
    $(node).find(".help-block").text("输入正确了！");
  });
}

function display_error(dom, message) {
  dom.closest(".form-group").addClass("has-error");
  dom.next(".help-block").text(message);
}

function valid_email_address(email) {
  var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
  return !!re.test(email);
}

function length_gt_than(str, len) {
  if(str.length >= len){
    return true;
  }

  return false;
}

function length_ql_to(str, len) {
  if(str.length == len){
    return true;
  }

  return false;
}

function string_same(str1, str2) {
  return str1 == str2
}

function email_validation(dom) {
  var $dom = $(dom),
  val = $dom.val();

  if(field_blank(val)){
    display_error($dom, "Email是必填内容， 请提供您的Email地址");
    return false;
  }

  if(!valid_email_address(val)){
    display_error($dom, "您填入的email地址不是个正确的地址");
    return false;
  }
  return true;
}

function password_validation(dom) {
  var $dom = $(dom),
  val = $dom.val();

  if(field_blank(val)){
    display_error($dom, "密码不能是空");
    return false;
  }

  if(!length_gt_than(val, 6)){
    display_error($dom, "您的密码长度不符合我们的要求");
    return false;
  }
  return true;
}

function password_confirmation_validation(dom) {
  var $dom = $(dom),
  val = $dom.val(),
  pass = $("#password_field").val();

  if(field_blank(val)){
    display_error($dom, "密码确认不能空， 请重复输入");
    return false;
  }

  if(!string_same(val, pass)){
    display_error($dom, "两次输入的密码不一致， 请核实");
    return false;
  }
  return true;
}

function captcha_validation(dom) {
  var $dom = $(dom),
  val = $dom.val();

  if(field_blank(val)){
    display_error($dom, "验证码不能空");
    return false;
  }

  if(!length_ql_to(val, 4)){
    display_error($dom, "您输入的验证码不正确");
    return false;
  }
  return true;
}

$("#register_form").submit(function (event) {

  cleanup_error();

  if(email_validation("#email_field") &&
     password_validation("#password_field") &&
       password_confirmation_validation("#password_confirmation_field") &&
         captcha_validation("#captcha_field"))
    {
      return true;
    }else{
      event.preventDefault();
    }
});

$("body").click(function () {
  
  cleanup_error();

  if(email_validation("#email_field") &&
     password_validation("#password_field") &&
         captcha_validation("#captcha_field"))
    {
      return true;
    }else{
      event.preventDefault();
    }

});
$("#login_form").submit(function (event) {

  cleanup_error();

  if(email_validation("#email_field") &&
     password_validation("#password_field") &&
         captcha_validation("#captcha_field"))
    {
      return true;
    }else{
      event.preventDefault();
    }

});

$("#forget_password_form").submit(function (event) {

  cleanup_error();

  if(email_validation("#email_field") && captcha_validation("#captcha_field"))
    {
      return true;
    }else{
      event.preventDefault();
    }
});
