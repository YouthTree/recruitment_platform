/* DO NOT MODIFY. This file was compiled Sat, 01 Jan 2011 13:56:33 GMT from
 * /Users/sutto/Code/YouthTree/recruitment_platform/app/coffeescripts/recruitment_platform/admin/paid_field.coffee
 */

RecruitmentPlatform.withNS('Admin.PaidField', function(ns) {
  ns.paidSelector = '#position_paid';
  ns.payDetailsSelector = '#position_paid_description_input';
  ns.updateFieldState = function() {
    if (ns.isPaid()) {
      return ns.payDetails.show();
    } else {
      return ns.payDetails.hide();
    }
  };
  ns.isPaid = function() {
    return ns.payField.is(':checked');
  };
  return ns.setup = function() {
    ns.payDetails = $(ns.payDetailsSelector);
    ns.payField = $(ns.paidSelector);
    return ns.payField.change(function() {
      return ns.updateFieldState();
    }).change();
  };
});