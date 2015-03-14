//= require zepto
//= require config
//= require logger
//= require fastclick
//= require wechat_config
//= require template_engine



$(document).ready(function() {
  $(".user_coupon_tab").click(function () {
    if($(this).hasClass("user_coupon_published")){
      $(".user_coupon_published").addClass("user_coupon_tab_actived");
      $(".user_coupon_owned").removeClass("user_coupon_tab_actived");
      setCouponPublishedActive();
    } else{
      $(".user_coupon_published").removeClass("user_coupon_tab_actived");
      $(".user_coupon_owned").addClass("user_coupon_tab_actived");
      setCouponOwnedActive();
    }
  });

  function setCouponPublishedActive() {
    $.getJSON('mobile_coupons/coupons_nearby', {lng: config.default_location.lng, lat: config.default_location.lat}, function (res) {
      $(".user_coupons_list").empty();
      res.forEach(function (item) {
        html = tmpl("item_tmpl", {item: item});
        $(".user_coupons_list").append(html);
      });

      $(".user_coupons_list .user_coupon_item").click(function () {
        window.location.href = "/mobile_coupons/" + $(this).data('id');
      });
    });
  }

  function setCouponOwnedActive() {
    $.getJSON('mobile_coupons/coupons_owned', {lng: config.default_location.lng, lat: config.default_location.lat}, function (res) {
      $(".user_coupons_list").empty();
      res.forEach(function (item) {
        html = tmpl("item_tmpl", {item: item});
        $(".user_coupons_list").append(html);
      });

      $(".user_coupons_list .user_coupon_item").click(function () {
        window.location.href = "/mobile_coupons/" + $(this).data('id') + "/coupon_show";
      });
    });
  }

  setCouponPublishedActive();
});

wx.ready(function () {
  wx.getLocation({
    type: 'gcj02',
    success: function (res) {
      var latitude = res.latitude; // 纬度，浮点数，范围为90 ~ -90
      var longitude = res.longitude; // 经度，浮点数，范围为180 ~ -180。
      var speed = res.speed; // 速度，以米/每秒计
      var accuracy = res.accuracy; // 位置精度

      $.getJSON('mobile_coupons/coupons_nearby', {lng: longitude, lat: lat}, function (res) {
        res.forEach(function (item) {
          html = tmpl("item_tmpl", {item: item});
          $(".user_coupons_list").append(html);
        });

        $(".user_coupons_list .user_coupon_item").click(function () {
          window.location.href = "/mobile_coupons/" + $(this).data('id');
        });
      });
    }
  });
});

