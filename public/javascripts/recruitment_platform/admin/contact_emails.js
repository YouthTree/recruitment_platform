/* DO NOT MODIFY. This file was compiled Fri, 31 Dec 2010 03:58:49 GMT from
 * /Users/sutto/Code/YouthTree/recruitment_platform/app/coffeescripts/recruitment_platform/admin/contact_emails.coffee
 */

RecruitmentPlatform.withNS('Admin.ContactEmails', function(ns) {
  ns.containerSelector = 'fieldset#contact-emails ol';
  ns.itemSelector = 'li.email';
  ns.removeInput = 'input.destroy-field';
  ns.addSelector = 'a.add-field';
  ns.removeSelector = '.remove-field';
  ns.htmlTemplate = '';
  ns.setTemplate = function(value) {
    return ns.htmlTemplate = value;
  };
  ns.render = function() {
    var idx;
    idx = (+new Date).toString();
    return $(ns.htmlTemplate.replace(/NEW_IDX/g, idx));
  };
  ns.bindRemoveButton = function(element) {
    element = $(element);
    return element.click(function(e) {
      var inner, remove;
      e.preventDefault();
      inner = $(this).parents(ns.itemSelector);
      remove = inner.find(ns.removeInput);
      if (remove.size() > 0) {
        remove.val('true');
        return inner.hide();
      } else {
        return inner.remove();
      }
    });
  };
  ns.addField = function() {
    var field;
    field = ns.render();
    ns.bindRemoveButton(field.find(ns.removeSelector));
    return ns.container.append(field);
  };
  ns.bindAddButton = function() {
    return ns.container.find(ns.addSelector).click(function(e) {
      e.preventDefault();
      return ns.addField();
    });
  };
  return ns.setup = function() {
    ns.container = $(ns.containerSelector);
    ns.container.find(ns.removeSelector).each(function() {
      return ns.bindRemoveButton(this);
    });
    return ns.bindAddButton();
  };
});