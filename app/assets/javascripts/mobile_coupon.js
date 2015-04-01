//= require zepto
//= require config
//= require logger
//= require fastclick
//= require wechat_config
//= require template_engine


var list_place_holder = $("<div id='list_place_holder'></div>");
var published_list_empty  = $("<div id='owned_list_empty'><div class='owned_list_empty_icon'></div><div class='owned_list_empty_text'>呜~还没有车场发布萝卜替你催！</div></div>");
var owned_list_empty  = $("<div id='owned_list_empty'><div class='owned_list_empty_icon'></div><div class='owned_list_empty_text'>呜~还没有抢到券萝卜等着你！</div></div>");

window.lastActiveLocation = null;
if(typeof localStorage.lastActivePostion !== 'undefined'){
  window.lastActiveLocation = {};
  window.lastActiveLocation.lng = localStorage.lastActivePostion.split(",")[0];
  window.lastActiveLocation.lat = localStorage.lastActivePostion.split(",")[1];
}


function showUserCouponListEmptyPage() {
  $(".user_coupons_list").empty();
  $(".user_coupons_list").append(list_place_holder);
}

function init() {
  var jump = window.location.hash.substring(1, window.location.hash.length) || "published";

  $(".user_coupon_tab").click(function () {
    if($(this).hasClass("user_coupon_published")){
      setCouponPublishedActive();
    } else{
      setCouponOwnedActive();
    }
  });

  function setCouponPublishedActive() {
    $(".user_coupon_published").addClass("user_coupon_tab_actived");
    $(".user_coupon_owned").removeClass("user_coupon_tab_actived");
    showUserCouponListEmptyPage();
    $.getJSON('mobile_coupons/coupons_nearby', {lng: window.lastActiveLocation.lng, lat: window.lastActiveLocation.lat, park_id: park_id}, function (res) {
      $(".user_coupons_list").empty();
      if(res.length != 0){
        res.forEach(function (item) {
          html = tmpl("item_tmpl", {item: item});
          $(".user_coupons_list").append(html);
        });

        $(".user_coupons_list .user_coupon_item").click(function () {
          window.location.href = "/mobile_coupons/" + $(this).data('id');
        });
      }else{
        $(".user_coupons_list").append(published_list_empty);
      }

      return true;
    });
  }

  function setCouponOwnedActive() {
    $(".user_coupon_published").removeClass("user_coupon_tab_actived");
    $(".user_coupon_owned").addClass("user_coupon_tab_actived");
    showUserCouponListEmptyPage();
    $.getJSON('mobile_coupons/coupons_owned', {lng: window.lastActiveLocation.lng, lat: window.lastActiveLocation.lat, park_id: park_id}, function (res) {
      $(".user_coupons_list").empty();
      if(res.length != 0){
        res.forEach(function (item) {
          html = tmpl("item_tmpl", {item: item});
          $(".user_coupons_list").append(html);
        });

        $(".user_coupons_list .user_coupon_item").click(function () {
          if($(this).hasClass("expired_coupon_item")){ return };
          if($(this).hasClass("used_coupon_item")){ return };

          window.location.href = "/mobile_coupons/" + $(this).data('id') + "/coupon_show";
        });
      }else{
        $(".user_coupons_list").append(owned_list_empty);
      }

      return true;
    });
  }

  jump == "published" ?  setCouponPublishedActive() : setCouponOwnedActive();
}

$(document).ready(function() {
  window.lastActiveLocation = window.lastActiveLocation || {};
  window.lastActiveLocation.lng = window.lastActiveLocation.lng || config.default_location.lng;
  window.lastActiveLocation.lat = window.lastActiveLocation.lat || config.default_location.lat;
  init();
});

//wx.ready(function () {
//wx.getLocation({
//type: wx.isAndroid ? 'gcj02' : 'wgs84',
//success: function (res) {
//var latitude = res.latitude; // 纬度，浮点数，范围为90 ~ -90
//var longitude = res.longitude; // 经度，浮点数，范围为180 ~ -180。
//var speed = res.speed; // 速度，以米/每秒计
//var accuracy = res.accuracy; // 位置精度
//window.lastActiveLocation = {};
//window.lastActiveLocation.lng = longitude;
//window.lastActiveLocation.lat = latitude;
//}
//});
//});


