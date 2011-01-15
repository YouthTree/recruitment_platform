/* DO NOT MODIFY. This file was compiled Sat, 15 Jan 2011 19:45:26 GMT from
 * /Users/sutto/Code/YouthTree/recruitment_platform/app/coffeescripts/youth_tree/ie6.coffee
 */

YouthTree.withNS('IE6', function(ns) {
  ns.belatedPNGSelectors = ["#page-header h1 a", "ul#social-media-icons li a", "#yt-subscribe-button button", "#flash-messages p.flash"];
  return ns.setup = function() {
    if (typeof DD_belatedPNG != "undefined" && DD_belatedPNG !== null) {
      return $(ns.belatedPNGSelectors.join(", ")).each(function() {
        return DD_belatedPNG.fixPng(this);
      });
    }
  };
});