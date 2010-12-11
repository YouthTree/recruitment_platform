/* DO NOT MODIFY. This file was compiled Sat, 11 Dec 2010 21:20:17 GMT from
 * /Users/sutto/.rvm/gems/ree-1.8.7-2010.02@recruitment_platform/gems/youthtree-js-0.4.1/coffeescripts/youth_tree/forms/convertable_editor.coffee
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  YouthTree.withNS('Forms.ConvertableEditor', function(ns) {
    var CKEditor;
    CKEditor = YouthTree.Forms.CKEditor;
    ns.containerSelector = 'fieldset.inputs.convertable';
    ns.editorSelector = 'textarea';
    ns.formatSelector = 'select';
    ns.showEditor = function(s) {
      return CKEditor.makeEditor(s);
    };
    ns.hideEditor = function(s) {
      return CKEditor.destroyEditor(s);
    };
    ns.shouldShowEditor = function(s) {
      return s.find(ns.formatSelector).val() === "raw";
    };
    ns.toggleEditorOn = function(scope) {
      var $scope;
      ns.debug(scope);
      $scope = $(scope);
      if (ns.shouldShowEditor($scope)) {
        return ns.showEditor($scope.find(ns.editorSelector));
      } else {
        return ns.hideEditor($scope.find(ns.editorSelector));
      }
    };
    ns.attachEvents = function() {
      return $(ns.containerSelector).each(function() {
        return $(this).find(ns.formatSelector).change(__bind(function() {
          return ns.toggleEditorOn(this);
        }, this));
      });
    };
    return ns.setup = function() {
      return ns.attachEvents();
    };
  });
}).call(this);
