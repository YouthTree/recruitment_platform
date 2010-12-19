RecruitmentPlatform.withNS 'Admin.QuestionEditor', (ns) ->

  # Selectors for various things.
  ns.addButtonClass    = 'a.questions-add-button'
  ns.removeButtonClass = 'a.question-remove-button'
  ns.removeField       = 'input.question-remove'
  ns.positionField     = 'input.question-order-position'
  ns.persistedSelector = 'input.question-id'
  ns.containerSelector = 'ol#position-questions-list'
  ns.questionSelector  = 'li.question-form'

  ns.updateFieldPositions = ->
    idx = 0
    $("#{ns.containerSelector} #{ns.questionSelector}").each ->
      current = $ this
      if current.find(ns.removeField).val() !== '1'
        current.find(ns.positionField).val ++idx

  ns.isPersisted = (field) ->
    field.find(ns.persistedSelector).size() > 0

  ns.removeField = (field) ->
    if ns.isPersisted field
      field.find(ns.removeField).val '1'
      field.hide()
    else
      field.remove()

  ns.setupQuestionField = (field) ->
    field.find(ns.removeButtonClass).click ->
      ns.removeButtonClass $(this).parents(ns.questionSelector)
      false

  ns.setup = ->
    $("#{ns.containerSelector} #{ns.questionSelector}").each ->
      ns.setupQuestionField $ this

