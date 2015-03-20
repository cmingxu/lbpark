//= require zepto
//= require config
//= require logger

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
            $("#autocomplete_list").append("<li data-name='" + place.name +"'><a>" + place.name + "<span> - " + place.district +"</span>" + "</a></li>");
          }
        });

        $("#autocomplete_list li").click(function() {
          $("#autocomplete_list").hide().empty();
          $("#search_input").val($(this).data('name'));
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

 $("#autocomplete_confirm_btn").click(function () {
   if($("#search_input").
      val().
        replace(/^\s+|\s+$/, '') == ""){
     return;
   }
   window.location.href = "/mobile/map?name=" + $("#search_input").val();
 });
});
