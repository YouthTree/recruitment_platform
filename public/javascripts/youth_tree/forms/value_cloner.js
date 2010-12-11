/* DO NOT MODIFY. This file was compiled Sat, 11 Dec 2010 21:20:17 GMT from
 * /Users/sutto/.rvm/gems/ree-1.8.7-2010.02@recruitment_platform/gems/youthtree-js-0.4.1/coffeescripts/youth_tree/forms/value_cloner.coffee
 */

(function() {
  YouthTree.withNS('Forms.ValueCloner', function(ns) {
    ns.cloneValue = function(from, to) {
      if (from.length && to.length) {
        return to.val(from.val());
      }
    };
    return ns.setup = function() {
      return $('a.clone-form-value').each(function() {
        var current, from_selector, to_selector;
        current = $(this);
        from_selector = current.dataAttr('clone-from');
        to_selector = current.dataAttr('clone-to');
        return current.click(function() {
          if ((from_selector != null) && (to_selector != null)) {
            ns.cloneValue($(from_selector), $(to_selector));
          }
          return false;
        });
      });
    };
  });
}).call(this);
