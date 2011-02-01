/* DO NOT MODIFY. This file was compiled Tue, 01 Feb 2011 12:51:22 GMT from
 * /Users/john/Projects/youthtree/recruitment_platform/app/coffeescripts/recruitment_platform/admin/team_editor.coffee
 */

RecruitmentPlatform.withNS('Admin.TeamEditor', function(ns) {
  var sortable;
  ns.dialogSelector = '#reorder-teams';
  ns.sortableSelector = 'ol';
  ns.linkSelector = '.reorder-teams-link';
  sortable = false;
  ns.showReorderDialog = function() {
    ns.makeSortable();
    return $(ns.dialogSelector).dialog();
  };
  ns.makeSortable = function() {
    var container;
    if (sortable) {
      return;
    }
    container = $("" + ns.dialogSelector + " " + ns.sortableSelector);
    container.sortable();
    container.disableSelection();
    return sortable = true;
  };
  ns.bindReorderButton = function() {
    return $(ns.linkSelector).click(function() {
      ns.showReorderDialog();
      return false;
    });
  };
  return ns.setup = function() {
    return ns.bindReorderButton();
  };
});