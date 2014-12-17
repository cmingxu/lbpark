var http_utils = {};

http_utils.get = function(path, params, callback) {
  $.ajax(path + "?" + $.param(params)).done(function (item) {
    for (var i = item.length - 1; i >= 0; i --) {
      var v = item[i];
      callback(v);
    }
  });
}
