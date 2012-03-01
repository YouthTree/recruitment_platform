/* DO NOT MODIFY. This file was compiled Thu, 01 Mar 2012 10:38:44 GMT from
 * /Users/sutto/.rvm/gems/ree-1.8.7-2011.03@recruitment_platform/gems/youthtree-js-0.4.1/coffeescripts/youth_tree/gallery.coffee
 */

YouthTree.withNS('Gallery', function(ns) {
  var InnerGallery;
  InnerGallery = (function() {
    function InnerGallery(selector) {
      this.selector = selector;
      this.items = $(this.selector);
      this.urls = this.items.map(function() {
        return this.href;
      }).toArray();
      this.bindEvents();
    }
    InnerGallery.prototype.bindEvents = function() {
      var self;
      self = this;
      return this.items.click(function(e) {
        e.preventDefault();
        self.showFor(this);
        return false;
      });
    };
    InnerGallery.prototype.showFor = function(element) {
      var href, index;
      href = element.href;
      index = this.urls.indexOf(href);
      if (index >= 0) {
        return this.showImages(this.urls.slice(index).concat(this.urls.slice(0, index)));
      }
    };
    InnerGallery.prototype.showImages = function(images) {
      return $.facybox({
        images: images
      });
    };
    return InnerGallery;
  })();
  ns.galleries = {};
  ns.create = function(name, selector) {
    var gallery;
    gallery = new InnerGallery(selector);
    ns.galleries[name] = gallery;
    return gallery;
  };
  return ns.get = function(name) {
    return ns.galleries[name];
  };
});