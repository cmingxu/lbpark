//= require zepto
//= require config

function hotPlaceSearch(keywords) {
  AMap.service(["AMap.Autocomplete"], function() { 
    if("" == keywords){
      $("#autocomplete_list").hide().empty();
    }
    autocomplete = new AMap.Autocomplete({
      city: "010"
    });
    autocomplete.search(keywords, function(status, result){
      //根据服务请求状态处理返回结果
      if(status=='complete') {
        $("#autocomplete_list").show().empty();
        result.tips.forEach(function (place) {
          if((typeof place.district === "string") && place.district.match(/北京/)){ // skip places out of beijing
            $("#autocomplete_list").append("<li><a href='/mobile/map?name=" + encodeURIComponent(place.name) + "'>" + place.name + "<span> - " + place.district +"</span>" + "</a></li>");
          }
        });
      }
      if(status=='no_data') {
        LB.Logger.deubg("没找到");
      }
      else {
        LB.Logger.debug(result);
      }
    });
  });
}

$(document).ready(function () {
  var latest_value = $("#search_input");
  ["keyup", "change", "blur", "input", "paste"].forEach(function (event, index) {
    $("#search_input").on(event, function () {
      if(latest_value != $("#search_input").val()){
        latest_value = $("#search_input").val();
        hotPlaceSearch(latest_value);
      }
    });
  });
});
