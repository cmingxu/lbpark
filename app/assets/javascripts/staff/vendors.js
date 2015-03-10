$(document).ready(function () {

  if($("#by_day, #by_hour, #by_vendor").length != 0){
    var x = d3.scale.linear()
    .domain([0, d3.max(data.map(function (i) { return i[1]; }))])
    .range([0, 620]);
    var p = d3.select("#by_day, #by_hour, #by_vendor").
      selectAll('p').
      data(data).
      enter().
      append("p");

    p.append("span").text(function (d) {
      return d[0];
    }).style("font-weight", 700).
      style("padding-right", "20px");

    span = p.append("span").
      style("background-color", "#7dc33a").
      style("display", "inline-block").
      style("height", "20px").
      style("width", function (d) {
      return "" + x(d[1]) + "px";
    });

    span.text(function (d) {
      return d[1];
    }).style("font-weight", 700).
      style("text-align", "right").
      style("padding-right", "10px").
      style("color", "white");
  };


  if($("#retention").length != 0){
    var retention_interval = [""];
    for(var i = 2; i < 30; i++){ retention_interval.push(i); }

    var table = d3.select("#retention").
      append('table');

    table.style("width", "100%");
    table.classed("table table-bordered", true);

    var thead = table.append("thead");

    thead.selectAll("td").data(retention_interval).
      enter().
      append("td").
      text(function (d) {  return d == "" ?  "" : "" + d + "日";});

    var tr = table.selectAll("tr").
      data(data).
      enter().
      append("tr").
      attr("data-date", function (d) { return d[0] });

    tr.
      append("td").
      text(function (d) { return d[0] }).
      style("background-color", "#476a94").
      style("color", "white");

    tr.
      selectAll('td').
      data(retention_interval).
      enter().
      append('td').
      style("background-color", function (d) { return "rgba(255, 0, 0," + retention_rate_for(tr.attr('data-date'), d) + ")" }).
      style('color', 'white').
      text(function (d) { return retention_rate_for(tr.attr('data-date'), d) });

    function retention_rate_for(date, interval) {
      var install_date = moment(date).add(-interval, 'd');
      install_date_str = install_date.format("YYYY-MM-DD");
      if(data_for_date(install_date_str).length == 0){ return 0; }
      return (_.intersection(data_for_date(date), data_for_date(install_date_str)).length / data_for_date(install_date_str).length).toFixed(3)
    }

    function data_for_date(date) {
      return _.uniq((_.find(data,  function (n) { return n[0] == date; }) || [[], []])[1]);
    }
  };
});
