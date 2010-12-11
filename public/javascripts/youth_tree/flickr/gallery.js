/* DO NOT MODIFY. This file was compiled Sat, 11 Dec 2010 21:20:17 GMT from
 * /Users/sutto/.rvm/gems/ree-1.8.7-2010.02@recruitment_platform/gems/youthtree-js-0.4.1/coffeescripts/youth_tree/flickr/gallery.coffee
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  YouthTree.withNS('Flickr.Gallery', function(ns) {
    var InnerFlickrGallery, flickr;
    flickr = YouthTree.Flickr;
    ns.navigationClass = 'flickr-gallery-navigation';
    ns.containerClass = 'flickr-gallery';
    InnerFlickrGallery = function() {
      function InnerFlickrGallery(name, container) {
        this.name = name;
        this.container = container;
        this.container.addClass(ns.containerClass);
      }
      InnerFlickrGallery.prototype.fetchPhotoset = function(photosetId, extraParams) {
        var params;
        params = {
          photoset_id: photosetId,
          extras: 'url_sq,url_m'
        };
        if (extraParams != null) {
          $.extend(params, extraParams);
        }
        return flickr.apiCall('flickr.photosets.getPhotos', params, __bind(function(response) {
          return this.process(response.photoset.photo);
        }, this));
      };
      InnerFlickrGallery.prototype.fetchUserTagged = function(user, tag, extraParams) {
        var params;
        params = {
          tags: tag,
          user_id: user,
          sort: 'interestingness-desc',
          content_type: '1',
          media: 'photos'
        };
        if (extraParams != null) {
          $.extend(params, extraParams);
        }
        return flickr.apiCall('flickr.photos.search', params, __bind(function(response) {
          return this.process(response.photos.photo);
        }, this));
      };
      InnerFlickrGallery.prototype.process = function(photos) {
        this.container.empty();
        $.each(photos, __bind(function(i, item) {
          var img, link;
          img = $('<img/>').attr('src', item.url_sq);
          link = $('<a></a>').attr('href', item.url_m).append(img);
          return this.container.append(link);
        }, this));
        return YouthTree.Gallery.create(this.name, this.container.find('a'));
      };
      return InnerFlickrGallery;
    }();
    ns.fromPhotoset = function(name, container, photoset, extraParams) {
      var flickr_gallery;
      flickr_gallery = new InnerFlickrGallery(name, container);
      flickr_gallery.fetchPhotoset(photoset, extraParams);
      return flickr_gallery;
    };
    return ns.fromUserTag = function(name, container, user, tag, extraParams) {
      var flickr_gallery;
      flickr_gallery = new InnerFlickrGallery(name, container);
      flickr_gallery.fetchUserTagged(user, tag, extraParams);
      return flickr_gallery;
    };
  });
}).call(this);
