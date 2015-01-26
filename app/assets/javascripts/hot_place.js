//= require zepto
//= require config

function hotPlaceSearch(keywords) {
  AMap.service(["AMap.Autocomplete"], function() { 
        autocomplete = new AMap.Autocomplete({
            type: 1000,
            city: "010"
        });
        autocomplete.search(keywords, function(status, result){
            //根据服务请求状态处理返回结果
            if(status=='complete') {
              $("#autocomplete_list").show().empty();
              result.tips.forEach(function (place) {
                $("#autocomplete_list").append("<li><a href='/mobile/map?id=" + place.id + "'>" + place.name + "<span> - " + place.district +"</span>" + "</a></li>");
              });
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
        hotPlaceSearch(latest_value);
      }
    });
  });
});