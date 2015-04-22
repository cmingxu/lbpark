var LB = LB || {};

LB.Logger = {
  level_map: {
    "DEBUG": 1,
    "INFO": 2,
    "ERROR": 3
  },
  debug_level: "DEBUG",

  _log: function (level, content) {
    if(this.level_map[level] >= this.level_map[this.debug_level])
      console.log("[ " + level +" ] " + content);
  },
  debug: function (content) {
    this._log("DEBUG", content);
  },
  error: function (content) {
    this._log("ERROR", content);
  },
  info: function (content) {
    this._log("INFO", content);
  },
  map_view: function(lat, lng) {
    image = new Image();
    image.src = "/mobile/js_log?what=MAP_VIEW&lat=" + lat + "&lng=" + lng;
  },
  detail_view: function(park_id) {
    image = new Image();
    image.src = "/mobile/js_log?what=DETAIL_VIEW&park_id=" + park_id;
  },
  short_view: function(park_id) {
    image = new Image();
    image.src = "/mobile/js_log?what=SHORT_VIEW&park_id=" + park_id;
  },
  map_drag: function(lat, lng) {
    image = new Image();
    image.src = "/mobile/js_log?what=MAP_DRAG&lat=" + lat + "&lng=" + lng;
  },
  map_zoom: function(lat, lng, zoom_level) {
    image = new Image();
    image.src = "/mobile/js_log?what=MAP_ZOOM&lat=" + lat + "&lng=" + lng + "&zoom_level=" +　zoom_level;
  }


}
