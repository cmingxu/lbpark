;(function (w, d, undefined) {

  var toast = function () {
    if(window.$toast){
      return w.$toast;
    }

    $toast = w.$toast =  initializeToast();
    return $toast;
  };

  function initializeToast() {
    toast = d.createElement("div");

    return function (msg) {
      toast.innerHTML = msg;
      toast.setAttribute("id", "toast");
      d.body.insertBefore(toast, d.body.firstChild);
      console.log('11222');
      console.log(toast);
      setTimeout(function () {
        d.body.removeChild(toast);
      }, 3000)};
  };

  toast();

}


)(window, document);
