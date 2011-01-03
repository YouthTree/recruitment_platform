/* DO NOT MODIFY. This file was compiled Sun, 02 Jan 2011 19:19:18 GMT from
 * /Users/sutto/Code/YouthTree/recruitment_platform/app/coffeescripts/youth_tree/network.coffee
 */

YouthTree.withNS('Network', function(ns) {
  ns.buttonSelector = '#yt-subscribe';
  ns.panelSelector = '#yt-subscribe-panel';
  ns.showPanel = function(link, e) {
    e.preventDefault();
    $(link).addClass('active');
    return ns.panel.slideDown();
  };
  ns.hidePanel = function(link, e) {
    e.preventDefault();
    $(link).removeClass('active');
    return ns.panel.slideUp();
  };
  ns.wrapperFor = function(f) {
    return function(e) {
      return f(this, e);
    };
  };
  ns.setupSubscriptionToggler = function() {
    ns.panel = $(ns.panelSelector);
    return $(ns.buttonSelector).toggle(ns.wrapperFor(ns.showPanel), ns.wrapperFor(ns.hidePanel));
  };
  return ns.setup = function() {
    return ns.setupSubscriptionToggler();
  };
});