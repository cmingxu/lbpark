//= require zepto
//= require config
//= require logger



$(document).ready( function () {
  $("a").click(function () {
    $.post(config.park_statuses_path, {"status": Math.floor((Math.random() * 3))});
  });
  }
);
