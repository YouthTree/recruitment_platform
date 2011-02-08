/* DO NOT MODIFY. This file was compiled Tue, 08 Feb 2011 08:49:13 GMT from
 * /Users/sutto/Code/YouthTree/recruitment_platform/app/coffeescripts/recruitment_platform/admin/analytics.coffee
 */

RecruitmentPlatform.withNS('Admin.Analytics', function(ns) {
  var formatDays;
  ns.apiBaseUrl = "http://api.getclicky.com/api/stats/4";
  ns.defaultParams = {
    output: "json",
    date: "last-7-days",
    daily: 1
  };
  ns.addSiteParams = function(params) {
    var site_id, site_key;
    site_id = $.metaAttr("clicky-site-id");
    if (site_id != null) {
      params.site_id = site_id;
    }
    site_key = $.metaAttr("clicky-site-key");
    if (site_key != null) {
      params.sitekey = site_key;
    }
    return params;
  };
  ns.mergedParams = function(newParams) {
    var params;
    params = $.extend({}, ns.defaultParams, newParams);
    ns.addSiteParams(params);
    return $.param(params);
  };
  ns.load = function() {};
  ns.showVisitData = function(data) {
    var days, groups;
    groups = {};
    days = $.map(data[0].dates, function(d) {
      return d.date;
    }).reverse();
    $.each(data, function() {
      return groups[this.type] = $.map(this.dates, function(d) {
        return Number(d.items[0].value);
      }).reverse();
    });
    return ns.showVisitChart(days, groups);
  };
  formatDays = function(days) {
    return $.map(days, function(day) {
      return day.split("-").reverse().join("/");
    });
  };
  ns.showVisitChart = function(days, groups) {
    return RecruitmentPlatform.Admin.ColumnChart.create('visits-chart', function() {
      this.setCategories(formatDays(days));
      this.setSideTitle('Visitors per Day');
      this.addSeries('Visitors', groups['visitors']);
      this.addSeries('Unique Visitors', groups['visitors-unique']);
      return this.setDataToolTip(function() {
        return "" + this.y + " " + (this.series.name.toLowerCase()) + "<br/>on " + this.x + ".";
      });
    });
  };
  ns.getVisitData = function() {
    var url;
    url = "" + ns.apiBaseUrl + "?" + (ns.mergedParams({
      type: "visitors,visitors-unique"
    })) + "&json_callback=?";
    return $.getJSON(url, ns.showVisitData);
  };
  return ns.setup = function() {
    return ns.getVisitData();
  };
});