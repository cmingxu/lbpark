//= require zepto
//= require config
//= require logger



$(document).ready( function () {
  $("a").click(function () {
    $.post(config.park_statuses_path, {"status": $(this).data('code')});
  });
  }
);
