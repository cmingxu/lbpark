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


}
