//= require zepto
//= require config
//= require logger
//= require vendor/login



var LB = LB || {};
function pageInit() {
  $(".vendor").height(window.innerHeight - config.tabbar_height);
}


$(document).ready( function () {
  pageInit();

  $("#park_status_buttons a").click(function () {
    $(".popup").toggle();
    $("#confirm_box").toggle();
    $("#park_status_word").text(config.park_status[$(this).data('code')].text);
    LB.selected_status = $(this).data('code');
  });

  $("#confirm_no_button").click(function () {
    $(".popup").toggle();
    $("#confirm_box").toggle();
  });

  $("#confirm_yes_button").click(function () {
    $(".popup").toggle();
    $("#confirm_box").toggle();
    $.post(config.park_statuses_path, {"status": LB.selected_status}, function (res) {
      if(res.result){
        window.location.href = "/vendor/index";
      }
    });
  });


});
