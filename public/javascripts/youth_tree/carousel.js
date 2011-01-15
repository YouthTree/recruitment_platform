/* DO NOT MODIFY. This file was compiled Sat, 15 Jan 2011 19:45:26 GMT from
 * /Users/sutto/Code/YouthTree/recruitment_platform/app/coffeescripts/youth_tree/carousel.coffee
 */

var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
YouthTree.withNS('Carousel', function(ns) {
  var Carousel;
  ns.carouselSelector = '#carousel';
  ns.containerSelector = 'ul';
  ns.elementSelector = 'li';
  ns.carousels = [];
  ns.delay = 5000;
  Carousel = (function() {
    function Carousel(carousel) {
      this.carousel = carousel;
      this.index = 0;
      this.container = this.carousel.find(ns.containerSelector);
      this.elements = this.container.find(ns.elementSelector);
      this.elements.filter(":eq(" + this.index + ")").css('display', 'block');
      this.count = this.elements.size();
      this.elements.hover((__bind(function() {
        return this.pause();
      }, this)), (__bind(function() {
        return this.schedule();
      }, this)));
      this.schedule();
    }
    Carousel.prototype.schedule = function() {
      return this.timeout = setTimeout((__bind(function() {
        return this.next();
      }, this)), ns.delay);
    };
    Carousel.prototype.pause = function() {
      if (this.timeout != null) {
        clearTimeout(this.timeout);
        return delete this.timeout;
      }
    };
    Carousel.prototype.next = function() {
      var from, old_index, to;
      old_index = this.index++;
      this.index = this.index % this.count;
      from = this.elements.filter(":eq(" + old_index + ")");
      to = this.elements.filter(":eq(" + this.index + ")");
      from.fadeOut("slow");
      to.fadeIn("slow");
      if (this.timeout != null) {
        return this.schedule();
      }
    };
    return Carousel;
  })();
  return ns.setup = function() {
    return $(ns.carouselSelector).each(function() {
      return ns.carousels.push(new Carousel($(this)));
    });
  };
});