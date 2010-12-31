RecruitmentPlatform.withNS 'Admin.QuestionEditor', (ns) ->

  # Selectors for various things.
  ns.removeButtonClass    = 'a.question-remove-button'
  ns.removeFieldSelector  = 'input.question-remove'
  ns.positionField        = 'input.question-order-position'
  ns.questionIdSelector   = 'input.question-question-id'
  ns.persistedSelector    = 'input.question-id'
  ns.containerSelector    = 'ol#position-questions-list'
  ns.questionSelector     = 'li.question-form'
  ns.nameSelector         = 'span.question-question'
  ns.nextQuestionSelector = 'select#position_next_question_id'
  ns.htmlTemplate         = '<li></li>'

  ns.updateQuestionSelectorState = ->
    selector = $ ns.nextQuestionSelector
    if selector.find('option').size() < 2
      selector.attr 'disabled', 'disabled'
    else
      selector.removeAttr 'disabled'

  ns.makeSortable = ->
    field = $ ns.containerSelector
    field.sortable update: (-> ns.updateFieldPositions())
    field.disableSelection()

  ns.refreshSorting = ->
    $(ns.containerSelector).sortable "refresh"

  ns.setTemplate = (template) ->
    ns.htmlTemplate = '' + template

  ns.render = ->
    idx = (+new Date).toString()
    $ ns.htmlTemplate.replace(/NEW_IDX/g, idx)

  ns.updateFieldPositions = ->
    idx = 0
    $("#{ns.containerSelector} #{ns.questionSelector}").each ->
      current = $ this
      if current.find(ns.removeFieldSelector).val() != '1'
        current.find(ns.positionField).val ++idx

  ns.isPersisted = (field) ->
    field.find(ns.persistedSelector).size() > 0

  ns.removeField = (field) ->
    name = field.find(ns.nameSelector).text()
    id   = field.find(ns.questionIdSelector).val()
    $(ns.nextQuestionSelector).append $("<option />", text: name, val: id)
    if ns.isPersisted field
      field.find(ns.removeFieldSelector).val '1'
      field.hide()
    else
      field.remove()
    ns.updateFieldPositions()
    ns.refreshSorting()
    ns.updateQuestionSelectorState()

  ns.setupQuestionField = (field) ->
    field.find(ns.removeButtonClass).click ->
      ns.removeField $(this).parents(ns.questionSelector)
      false

  ns.addField = ->
    next_question = $ ns.nextQuestionSelector
    current_option = next_question.find "option:selected"
    return if current_option.size() is 0
    id   = current_option.val()
    name = current_option.text()
    return if $.trim(id) is ''
    current_option.remove()
    # Find for existing fields.
    @debug "Adding question", name, "with id", id
    existing = $("#{ns.containerSelector} #{ns.questionSelector} #{ns.questionIdSelector}[value='#{id}']")
    if existing.size() > 0
      existing = existing.parents(ns.questionSelector)
      existing.find(ns.removeFieldSelector).val '0'
      existing.show()
      existing.appendTo $(ns.containerSelector)
    else
      new_field = ns.render()
      new_field.find(ns.nameSelector).text name
      new_field.find(ns.questionIdSelector).val id
      ns.setupQuestionField new_field
      new_field.appendTo $(ns.containerSelector)
    ns.updateFieldPositions()
    ns.refreshSorting()
    ns.updateQuestionSelectorState()


  ns.setup = ->
    $("#{ns.containerSelector} #{ns.questionSelector}").each ->
      ns.setupQuestionField $ this
    $(ns.nextQuestionSelector).change -> ns.addField()
    ns.makeSortable()
    ns.updateQuestionSelectorState()

