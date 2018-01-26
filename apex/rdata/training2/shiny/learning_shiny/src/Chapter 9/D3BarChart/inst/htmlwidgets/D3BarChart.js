HTMLWidgets.widget({

  name: 'D3BarChart',

  type: 'output',

  initialize: function(el, width, height) {

    return {};

  },

  renderValue: function(el, x, instance) {

// Variable definitions

    var jsdata = HTMLWidgets.dataframeToD3(x.inpdata);
    var hei = el.offsetHeight/jsdata.length;
    var maxwid = Math.max.apply(Math,jsdata.map(function(o){return eval('o.' + x                  .plotvar)}));
    var y = d3.scale.linear()
                .domain([0, maxwid])
                .range([0, el.offsetWidth]);
    var tooltipsdiv = d3.select(el)
                .append("div")
                .attr("class", "tooltips");


//Remove old widget. Important for Shiny Applications.

d3.select(el).select("svg").remove();

//Rectangles drawings

        d3.select(el)
        .append("svg")
        .attr("width", el.offsetWidth)
       .attr("height", el.offsetHeight)
      .selectAll("rect")
      .data(jsdata)
      .enter()
      .append("rect")
      .attr("width", function(d) { return y(eval('d.' + x.plotvar)); })
      .attr("height", hei)
      .attr("transform", function(d,i) { return "translate(0," + i * hei + ")"; })
      .attr("style", "fill:blue; stroke:white")
      .on("mouseover", function(d) {
  	    tooltipsdiv
  	    //.transition()
		    //.duration(20)
		    .attr("style", "display: block; left: " + d3.event.pageX + "px; top: " + d3          .event.pageY + "px;")
		    .text(x.tooltip + " : " + eval("d." + x.tooltip));
		                                })
      .on("mouseout", function(d) {
      tooltipsdiv
      .attr("style", "display: none;")
      ;});


  },

  resize: function(el, width, height, instance) {


  }

});
