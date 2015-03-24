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
        result.tips.slice(0, 6).forEach(function (place) {
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

function storeSearchPlace(place) {
  if(!localStorage)
    return;

  if(!localStorage.hot_places)
    localStorage.hot_places = "";

  hot_places = localStorage.hot_places.split(",")
  if(hot_places.indexOf(place) != -1){
    return;
  }

  hot_places.push(place);
  $(".search_history").addClass("hidden");
  localStorage.hot_places = hot_places.join(',');
}

function removeSearchPlace(place) {
  hot_places = localStorage.hot_places.split(',');
  var index = hot_places.indexOf(place);
  if(index == -1){
    return
  }
  hot_places.splice(index, 1);
  if(hot_places.length == 0){
    $(".search_history").removeClass("hidden");
  }
  localStorage.hot_places = hot_places.join(',');
}

function emptySearchPlaces() {
  localStorage.hot_places = "";
  $(".search_history").addClass("hidden");
}

$(document).ready(function () {
  if( typeof localStorage.hot_places === 'undefined') localStorage.hot_places = "";
  for(i=0; i<localStorage.hot_places.split(',').length; i++){
    if(localStorage.hot_places.split(",")[i] == ""){ continue };
    $("#search_history").prepend($("<div class='search_history_item'><div class='search_history_item_icon'></div><div class='search_history_item_name'>" + localStorage.hot_places.split(',')[i]+ "</div><div class='search_history_item_remove_icon'></div></div>"));
  }

  if(localStorage.hot_places.split(',').length == 0){
    $(".search_history").removeClass("hidden");
  }
  $("#search_history .search_history_item").click(function () {
    window.location.href = "/mobile/map?name=" + $(this).text();
  });

  $("#search_history .search_history_item .search_history_item_remove_icon").click(function (event) {
    removeSearchPlace($(this).parent().text());
    event.stopPropagation();
    window.location.reload();
  });
  var latest_value = $("#search_input");
  ["keyup", "change", "blur", "input", "paste"].forEach(function (event, index) {
    $("#search_input").on(event, function () {
      if(latest_value != $("#search_input").val()){
        latest_value = $("#search_input").val();
        hotPlaceSearch(latest_value);
      }
    });
  });

  $(".search_history_empty").click(function () {
    emptySearchPlaces();
    window.location.reload();
  });

  $("#autocomplete_confirm_btn").click(function () {
    if($("#search_input").
       val().
         replace(/^\s+|\s+$/, '') == ""){
      return;
    }
    storeSearchPlace($("#search_input").val().replace(/^\s+|\s+$/, ''));
    window.location.href = "/mobile/map?name=" + $("#search_input").val();
  });
});
