wx.ready(function () {
  $("#scanQRCode").click(function (event) {
    wx.scanQRCode({
      needResult: 1, // 默认为0，扫描结果由微信处理，1则直接返回扫描结果，
      success: function (res) {
        var result = res.resultStr; // 当needResult 为 1 时，扫码返回的结果
        setTimeout(function () {
          window.location.href = "/vendor_coupons/" + result + "/use";
        }, 500);
      }
    });
  })
});

