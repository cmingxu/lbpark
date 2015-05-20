// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require kindeditor
//= require bootstrap-sprockets
//= require bootstrap-datepicker
//= require underscore
//= require underscore.string
//= require session
//= require d3
//= require moment


function date_class_event_attach() {
  $('.date').datepicker({
    format: 'yyyy-mm-dd',
    startDate: '-0d'
  });
}

$(document).ready(function () {

  date_class_event_attach();

  $(".overlay_dom").on('click', function () {
    $("#overlay_container").load($(this).data("url"), function () {
      date_class_event_attach();
      $("#overlay").show();
    });

    $("#overlay_container").click(function () {
      event.stopPropagation();
    });

    $("#overlay").click(function () {
      $(this).hide();
    });
  });
});

