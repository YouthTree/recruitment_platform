/* DO NOT MODIFY. This file was compiled Sun, 12 Dec 2010 09:04:41 GMT from
 * /Users/sutto/.rvm/gems/ree-1.8.7-2010.02@recruitment_platform/gems/youthtree-js-0.4.1/coffeescripts/youth_tree/disqus.coffee
 */

YouthTree.withNS('Disqus', function(ns) {
  ns.collectionSelector = '#posts';
  ns.currentIdentifier = function() {
    return $.metaAttr("disqus-identifier");
  };
  ns.currentSite = function() {
    return $.metaAttr("disqus-site");
  };
  ns.isDebug = function() {
    return $.metaAttr("disqus-developer") === "true";
  };
  ns.configureDisqus = function() {
    window.disqus_identifier = ns.currentIdentifier();
    if (ns.isDebug()) {
      return window.disqus_developer = 1;
    }
  };
  ns.addScripts = function() {
    var script;
    ns.configureDisqus();
    script = $("<script />", {
      type: "text/javascript",
      async: true
    });
    if ($(ns.collectionSelector).size() > 0) {
      script.attr("src", "http://disqus.com/forums/" + (ns.currentSite()) + "/count.js");
    } else {
      script.attr("src", "http://" + (ns.currentSite()) + ".disqus.com/embed.js");
    }
    return script.appendTo($("head"));
  };
  return ns.setup = function() {
    return ns.addScripts();
  };
});