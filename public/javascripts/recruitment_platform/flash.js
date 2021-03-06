/* DO NOT MODIFY. This file was compiled Sun, 09 Jan 2011 13:50:40 GMT from
 * /Users/sutto/Code/YouthTree/recruitment_platform/app/coffeescripts/recruitment_platform/flash.coffee
 */

RecruitmentPlatform.withNS('Flash', function(ns) {
  ns.parentSelector = '#flash-messages';
  ns.insideSelector = 'p.flash';
  ns.hideTimeout = 15000;
  ns.hideAllFlash = function() {
    return $("" + ns.parentSelector + " " + ns.insideSelector).each(function() {
      return ns.hideFlash(this);
    });
  };
  ns.hideFlash = function(e) {
    return $(e).slideUp(function() {
      return $(this).remove();
    });
  };
  ns.setupTimers = function() {
    return setTimeout((function() {
      return ns.hideAllFlash();
    }), ns.hideTimeout);
  };
  ns.attachClickEvents = function() {
    return $("" + ns.parentSelector + " " + ns.insideSelector).click(function() {
      ns.hideFlash(this);
      return false;
    });
  };
  return ns.setup = function() {
    if ($(ns.parentSelector).size() < 1) {
      return;
    }
    ns.setupTimers();
    return ns.attachClickEvents();
  };
});