/* DO NOT MODIFY. This file was compiled Tue, 08 Feb 2011 08:48:38 GMT from
 * /Users/sutto/Code/YouthTree/recruitment_platform/app/coffeescripts/recruitment_platform/admin/charts.coffee
 */

var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
RecruitmentPlatform.withNS('Admin', function(ns) {
  ns.BaseChart = (function() {
    BaseChart.getChartType = function() {
      throw 'Implement Chart Type';
    };
    function BaseChart(id) {
      this.id = id;
      this.parent = $("#" + this.id).parents('.statistic');
      this.buildInitialOptions();
    }
    BaseChart.prototype.buildInitialOptions = function() {
      return this.options = {
        chart: {
          renderTo: this.id,
          defaultSeriesType: this.getChartType(),
          backgroundColor: this.parent.css('background-color'),
          marginTop: 20
        },
        xAxis: {
          categories: []
        },
        yAxis: {
          min: 0
        },
        legend: {
          enabled: true
        },
        title: {
          text: ''
        },
        series: []
      };
    };
    BaseChart.prototype.setSideTitle = function(title) {
      return this.options.yAxis.title = {
        text: title
      };
    };
    BaseChart.prototype.setCategories = function(c) {
      return this.options.xAxis.categories = c;
    };
    BaseChart.prototype.setTitle = function(t) {
      var _base, _ref;
      (_ref = (_base = this.options).title) != null ? _ref : _base.title = {};
      return this.options.title.text = t;
    };
    BaseChart.prototype.setDataToolTip = function(tooltip) {
      return this.options.tooltip = {
        formatter: tooltip
      };
    };
    BaseChart.prototype.addSeries = function(name, data) {
      return this.options.series.push({
        name: name,
        data: data
      });
    };
    BaseChart.prototype.draw = function() {
      this.parent.removeClass('hidden-container');
      $("#" + this.id).empty().show();
      return new Highcharts.Chart(this.options);
    };
    return BaseChart;
  })();
  ns.withNS('LineChart', function(lineNS) {
    var InnerChart;
    InnerChart = (function() {
      function InnerChart() {
        InnerChart.__super__.constructor.apply(this, arguments);
      }
      __extends(InnerChart, ns.BaseChart);
      InnerChart.prototype.getChartType = function() {
        return 'line';
      };
      return InnerChart;
    })();
    return lineNS.create = function(id, cb) {
      var chart;
      chart = new InnerChart(id);
      if (typeof cb === "function") {
        cb.apply(chart);
      }
      chart.draw();
      return chart;
    };
  });
  ns.withNS('ColumnChart', function(columnNS) {
    var InnerChart;
    InnerChart = (function() {
      function InnerChart() {
        InnerChart.__super__.constructor.apply(this, arguments);
      }
      __extends(InnerChart, ns.BaseChart);
      InnerChart.prototype.getChartType = function() {
        return 'column';
      };
      return InnerChart;
    })();
    return columnNS.create = function(id, cb) {
      var chart;
      chart = new InnerChart(id);
      if (typeof cb === "function") {
        cb.apply(chart);
      }
      chart.draw();
      return chart;
    };
  });
  return ns.withNS('PieChart', function(pieNS) {
    var InnerChart;
    InnerChart = (function() {
      function InnerChart() {
        InnerChart.__super__.constructor.apply(this, arguments);
      }
      __extends(InnerChart, ns.BaseChart);
      InnerChart.prototype.getChartType = function() {
        return 'pie';
      };
      InnerChart.prototype.emptyFormatter = function() {
        return this.options.plotOptions.pie.dataLabels.formatter = function() {
          return '';
        };
      };
      InnerChart.prototype.buildInitialOptions = function() {
        return this.options = {
          chart: {
            renderTo: this.id,
            defaultSeriesType: this.getChartType(),
            backgroundColor: this.parent.css('background-color')
          },
          plotOptions: {
            pie: {
              dataLabels: {
                enabled: true,
                formatter: function() {
                  return this.point.name;
                },
                style: {
                  fontWeight: 'bold'
                }
              }
            }
          },
          xAxis: {
            categories: []
          },
          yAxis: {
            min: 0
          },
          legend: {
            enabled: true,
            layout: 'horizontal',
            backgroundColor: '#FFFFFF',
            style: {
              marginTop: '10px'
            }
          },
          title: {
            text: ''
          },
          series: []
        };
      };
      InnerChart.prototype.addSeries = function(name, labels, data) {
        var item, label, seriesData;
        seriesData = {
          type: 'pie',
          name: name,
          data: []
        };
        labels = labels.slice(0);
        while (labels.length > 0) {
          label = labels.shift();
          item = data.shift();
          seriesData.data.push([label, item]);
        }
        return this.options.series.push(seriesData);
      };
      return InnerChart;
    })();
    return pieNS.create = function(id, cb) {
      var chart;
      chart = new InnerChart(id);
      if (typeof cb === "function") {
        cb.apply(chart);
      }
      chart.draw();
      return chart;
    };
  });
});