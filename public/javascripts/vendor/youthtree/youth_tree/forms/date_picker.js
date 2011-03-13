/* DO NOT MODIFY. This file was compiled Sun, 13 Mar 2011 12:00:05 GMT from
 * /Users/sutto/.rvm/gems/ree-1.8.7-2011.03@recruitment_platform/gems/youthtree-js-0.4.1/coffeescripts/youth_tree/forms/date_picker.coffee
 */

YouthTree.withNS('Forms.DatePicker', function(ns) {
  ns.timeFormat = 'hh:mm TT';
  ns.dateFormat = 'dd MM yy';
  ns.makeDatePickers = function() {
    if ($.fn.datepicker == null) {
      return;
    }
    return $('input.ui-date-picker').datepicker({
      dateFormat: ns.dateFormat
    });
  };
  ns.makeDateTimePickers = function() {
    if ($.fn.datetimepicker == null) {
      return;
    }
    return $('input.ui-datetime-picker').datetimepicker({
      dateFormat: ns.dateFormat,
      timeFormat: ns.timeFormat,
      ampm: true
    });
  };
  return ns.setup = function() {
    return $(document).ready(function() {
      ns.makeDatePickers();
      return ns.makeDateTimePickers();
    });
  };
});