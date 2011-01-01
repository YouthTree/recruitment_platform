/* DO NOT MODIFY. This file was compiled Sat, 01 Jan 2011 13:56:33 GMT from
 * /Users/sutto/.rvm/gems/ree-1.8.7-2010.02@recruitment_platform/gems/youthtree-js-0.4.1/coffeescripts/youth_tree/forms/ck_editor.coffee
 */

YouthTree.withNS('Forms.CKEditor', function(ns) {
  var currentEditorOptions;
  window.CKEDITOR_BASEPATH = '/ckeditor/';
  ns.editorSelector = '.ckeditor textarea';
  ns.editorOptions = {
    toolbar: 'youthtree',
    width: '71%',
    customConfig: false
  };
  ns.toolbar_layout = [['Source', '-', 'Templates'], ['Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'SpellChecker', 'Scayt'], ['Undo', 'Redo', '-', 'Find', 'Replace', 'RemoveFormat'], '/', ['Bold', 'Italic', 'Underline', 'Strike'], ['NumberedList', 'BulletedList', 'Blockquote'], ['JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock'], ['Link', 'Unlink', 'Anchor'], ['Image', 'Flash', 'Table', 'HorizontalRule'], '/', ['Styles', 'Format', 'Font', 'FontSize'], ['TextColor', 'BGColor'], ['Maximize', 'ShowBlocks']];
  currentEditorOptions = function() {
    var options;
    options = $.extend({}, ns.editorOptions);
    options.toolbar_youthtree = ns.toolbar_layout;
    return options;
  };
  ns.makeEditor = function(jq) {
    return jq.ckeditor(currentEditorOptions());
  };
  ns.destroyEditor = function(jq) {
    var _ref;
    return (_ref = jq.ckeditorGet()) != null ? _ref.destroy() : void 0;
  };
  return ns.setup = function() {
    return ns.makeEditor($(ns.editorSelector));
  };
});