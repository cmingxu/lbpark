//= require zepto
//= require config
//= require logger
//= require vendor/login



function pageInit() {
  $(".vendor").height(window.innerHeight - config.tabbar_height);
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


});
