wx.ready(function () {
  $("#scanQRCode").click(function (event) {
    wx.scanQRCode({
      needResult: 1, // 默认为0，扫描结果由微信处理，1则直接返回扫描结果，
      scanType: ["qrCode"], // 可以指定扫二维码还是一维码，默认二者都有
      success: function (res) {
        console.log(res.resultStr);
        var result = res.resultStr; // 当needResult 为 1 时，扫码返回的结果
        window.location.href = "/vendor_coupons/" + result + "/use";
      },
      error: function (res) {
        $toast("扫码失败， 请反馈给萝卜停车...");
      }
    });
  })
});

