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
//= require bootstrap3-typeahead
//= require bootstrap-datepicker
//= require underscore
//= require underscore.string
//= require session
//= require d3
//= require moment
//= require staff/vendors


$(document).ready(function(){
    $('input.typeahead').typeahead({
      source: function (query, process) {
        $.ajax({
          url: "/staff/parks",
          type: "get",
          dataType: 'JSON',
          data: {match: query},
          success: function (data) {
            process(data);
          }
        })
      },
      afterSelect: function (item) {
        window.location.href = "/staff/parks/" + item.id + "/edit";
      }
    });

    $('input.typeahead_user_parks').typeahead({
      source: function (query, process) {
        $.ajax({
          url: "/staff/parks",
          type: "get",
          dataType: 'JSON',
          data: {match: query},
          success: function (data) {
            process(data);
          }
        })
      },
      afterSelect: function (item) {
        //window.location.href = "/staff/parks/" + item.id + "/edit";
        $(".typeahead_user_parks").val(item.id);
      }
    });

    $('input.typeahead_new_coupon').typeahead({
      source: function (query, process) {
        $.ajax({
          url: "/staff/parks",
          type: "get",
          dataType: 'JSON',
          data: {match: query},
          success: function (data) {
            process(data);
          }
        })
      },
      afterSelect: function (item) {
        //window.location.href = "/staff/parks/" + item.id + "/edit";
        $("#coupon_tpl_park_id").val(item.id);
      }
    });

    $('.date').datepicker({
      format: 'yyyy-mm-dd',
      startDate: '-1d'
    });
});
