wx.ready(function () {
  console.log('wechat ready');
});

wx.error(function (res) {
  console.log('errpr');
  console.log(res);
});
