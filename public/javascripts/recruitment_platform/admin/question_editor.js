/* DO NOT MODIFY. This file was compiled Sun, 19 Dec 2010 12:49:33 GMT from
 * /Users/sutto/Code/YouthTree/recruitment_platform/app/coffeescripts/recruitment_platform/admin/question_editor.coffee
 */

RecruitmentPlatform.withNS('Admin.QuestionEditor', function(ns) {
  ns.removeButtonClass = 'a.question-remove-button';
  ns.removeFieldSelector = 'input.question-remove';
  ns.positionField = 'input.question-order-position';
  ns.questionIdSelector = 'input.question-question-id';
  ns.persistedSelector = 'input.question-id';
  ns.containerSelector = 'ol#position-questions-list';
  ns.questionSelector = 'li.question-form';
  ns.nameSelector = 'span.question-question';
  ns.nextQuestionSelector = 'select#position_next_question_id';
  ns.htmlTemplate = '<li>BLAH</li>';
  ns.makeSortable = function() {
    var field;
    field = $(ns.containerSelector);
    field.sortable({
      update: (function() {
        return ns.updateFieldPositions();
      })
    });
    return field.disableSelection();
  };
  ns.refreshSorting = function() {
    return $(ns.containerSelector).sortable("refresh");
  };
  ns.setTemplate = function(template) {
    return ns.htmlTemplate = '' + template;
  };
  ns.render = function() {
    var idx;
    idx = (+new Date).toString();
    return $(ns.htmlTemplate.replace(/NEW_IDX/g, idx));
  };
  ns.updateFieldPositions = function() {
    var idx;
    idx = 0;
    return $("" + ns.containerSelector + " " + ns.questionSelector).each(function() {
      var current;
      current = $(this);
      if (current.find(ns.removeFieldSelector).val() !== '1') {
        return current.find(ns.positionField).val(++idx);
      }
    });
  };
  ns.isPersisted = function(field) {
    return field.find(ns.persistedSelector).size() > 0;
  };
  ns.removeField = function(field) {
    var id, name;
    name = field.find(ns.nameSelector).text();
    id = field.find(ns.questionIdSelector).val();
    $(ns.nextQuestionSelector).append($("<option />", {
      text: name,
      val: id
    }));
    if (ns.isPersisted(field)) {
      field.find(ns.removeFieldSelector).val('1');
      field.hide();
    } else {
      field.remove();
    }
    ns.updateFieldPositions();
    return ns.refreshSorting();
  };
  ns.setupQuestionField = function(field) {
    return field.find(ns.removeButtonClass).click(function() {
      ns.removeField($(this).parents(ns.questionSelector));
      return false;
    });
  };
  ns.addField = function() {
    var current_option, existing, id, name, new_field, next_question;
    next_question = $(ns.nextQuestionSelector);
    current_option = next_question.find("option:selected");
    if (current_option.size() === 0) {
      return;
    }
    id = current_option.val();
    name = current_option.text();
    if ($.trim(id) === '') {
      return;
    }
    current_option.remove();
    this.debug("Adding question", name, "with id", id);
    existing = $("" + ns.containerSelector + " " + ns.questionSelector + " " + ns.questionIdSelector + "[value='" + id + "']");
    if (existing.size() > 0) {
      existing = existing.parents(ns.questionSelector);
      existing.find(ns.removeFieldSelector).val('0');
      existing.show();
      existing.appendTo($(ns.containerSelector));
    } else {
      new_field = ns.render();
      new_field.find(ns.nameSelector).text(name);
      new_field.find(ns.questionIdSelector).val(id);
      ns.setupQuestionField(new_field);
      new_field.appendTo($(ns.containerSelector));
    }
    ns.updateFieldPositions();
    return ns.refreshSorting();
  };
  return ns.setup = function() {
    $("" + ns.containerSelector + " " + ns.questionSelector).each(function() {
      return ns.setupQuestionField($(this));
    });
    $(ns.nextQuestionSelector).change(function() {
      return ns.addField();
    });
    return ns.makeSortable();
  };
});