/* DO NOT MODIFY. This file was compiled Sun, 12 Dec 2010 09:04:41 GMT from
 * /Users/sutto/.rvm/gems/ree-1.8.7-2010.02@recruitment_platform/gems/youthtree-js-0.4.1/coffeescripts/youth_tree/flickr.coffee
 */

YouthTree.withNS('Flickr', function(ns) {
  ns.apiBaseURL = 'http://api.flickr.com/services/rest/';
  ns.defaultOptions = {
    format: 'json',
    api_key: ''
  };
  ns.defaultErrorHandler = function(response) {
    if (window.console != null) {
      return ns.log("Error: " + response.code + " - " + response.message);
    }
  };
  ns.apiCall = function(name, options, callback, errback) {
    var apiOptions;
    if (ns.apiKey == null) {
      return;
    }
    errback != null ? errback : errback = ns.defaultErrorHandler;
    apiOptions = {
      method: name
    };
    $.extend(apiOptions, options, ns.defaultOptions);
    return $.ajax({
      url: ns.apiBaseURL,
      dataType: 'jsonp',
      jsonp: 'jsoncallback',
      data: apiOptions,
      success: function(data) {
        if (data.stat === 'ok') {
          return callback(data);
        } else {
          return errback(data);
        }
      }
    });
  };
  return ns.setup = function() {
    ns.apiKey = $.metaAttr('flickr-api-key');
    return ns.defaultOptions.api_key = ns.apiKey;
  };
});