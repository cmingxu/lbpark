//= require zepto
//= require config
//= require logger
//= require fastclick
//= require toast
//= require bind_mobile



var LB = LB || {};
function pageInit() {
  $(".vendor").height(window.innerHeight - config.tabbar_height);
}


$(document).ready( function () {
  FastClick.attach(document.body);
  pageInit();

  $("#park_status_buttons a").click(function () {
    $(".popup").show('slow');
    $("#confirm_box").show('slow');
    $("#park_status_word").text(config.park_status[$(this).data('code')].text);
    LB.selected_status = $(this).data('code');
  });

  $("#confirm_no_button").click(function () {
    $(".popup").hide('slow');
    $("#confirm_box").hide('slow');
  });


  $(".popup").click(function () {
    $(".popup").hide('slow');
    $("#confirm_box").hide('slow');
  });

  $("#confirm_yes_button").click(function () {
    $(".popup").hide('slow');
    $("#confirm_box").hide('slow');
    $.post(config.park_statuses_path, {"status": LB.selected_status}, function (res) {
      if(res.result){
        $toast(res.msg);
      }
    });
  });


});
