//= require zepto
//= require config

function hotPlaceInit() {
  AMap.service(["AMap.Autocomplete"], function() { 
        autocomplete = new AMap.Autocomplete({
            type: 1000,
            city: "北京"
        });
        autocomplete.search("中", function(status, result){
            //根据服务请求状态处理返回结果
            if(status=='complete') {
              console.log(result);
            }
            if(status=='no_data') {
              console.log("没找到");
            }
            else {
                console.log(result);
            }
        });
});
}

$(document).ready(function () {
  var latest_value = $("#search_input");
  ["keyup", "change"].forEach(function (event, index) {

    $("#search_input").on(event, function () {

      if(latest_value != $("#search_input").val()){
        latest_value = $("#search_input").val();
        $("body").append("<span>1</span>");
      }
      //console.log($('#search_input').val());
    });
  });
});
