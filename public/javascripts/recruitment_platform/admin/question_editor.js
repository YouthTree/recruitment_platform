/* DO NOT MODIFY. This file was compiled Sun, 19 Dec 2010 10:22:20 GMT from
 * /Users/sutto/Code/YouthTree/recruitment_platform/app/coffeescripts/recruitment_platform/admin/question_editor.coffee
 */

RecruitmentPlatform.withNS('Admin.QuestionEditor', function(ns) {
  ns.addButtonClass = 'a.questions-add-button';
  ns.removeButtonClass = 'a.question-remove-button';
  ns.removeField = 'input.question-remove';
  ns.positionField = 'input.question-order-position';
  ns.persistedSelector = 'input.question-id';
  ns.containerSelector = 'ol#position-questions-list';
  ns.questionSelector = 'li.question-form';
  ns.updateFieldPositions = function() {
    var idx;
    idx = 0;
    return $("" + ns.containerSelector + " " + ns.questionSelector).each(function() {
      var current;
      current = $(this);
      if (current.find(ns.removeField).val() !== '1') {
        return current.find(ns.positionField).val(++idx);
      }
    });
  };
  ns.isPersisted = function(field) {
    return field.find(ns.persistedSelector).size() > 0;
  };
  ns.removeField = function(field) {
    if (ns.isPersisted(field)) {
      field.find(ns.removeField).val('1');
      return field.hide();
    } else {
      return field.remove();
    }
  };
  ns.setupQuestionField = function(field) {
    return field.find(ns.removeButtonClass).click(function() {
      ns.removeButtonClass($(this).parents(ns.questionSelector));
      return false;
    });
  };
  return ns.setup = function() {
    return $("" + ns.containerSelector + " " + ns.questionSelector).each(function() {
      return ns.setupQuestionField($(this));
    });
  };
});