RecruitmentPlatform.withNS 'Admin.ContactEmails', (ns) ->

  ns.containerSelector = 'fieldset#contact-emails ol'
  ns.itemSelector      = 'li.email'
  ns.removeInput       = 'input.destroy-field'
  ns.addSelector       = 'a.add-field'
  ns.removeSelector    = '.remove-field'
  ns.htmlTemplate      = ''

  ns.setTemplate = (value) ->
    ns.htmlTemplate = value

  ns.render = ->
    idx = (+new Date).toString()
    $ ns.htmlTemplate.replace(/NEW_IDX/g, idx)

  ns.bindRemoveButton = (element) ->
    element = $ element
    element.click (e) ->
      e.preventDefault()
      inner = $(this).parents ns.itemSelector
      remove = inner.find ns.removeInput
      if remove.size() > 0
        remove.val 'true'
        inner.hide()
      else
        inner.remove()

  ns.addField = ->
    field = ns.render()
    ns.bindRemoveButton field.find(ns.removeSelector)
    ns.container.append field


  ns.bindAddButton = ->
    ns.container.find(ns.addSelector).click (e) ->
      e.preventDefault()
      ns.addField()

  ns.setup = ->
    ns.container = $ ns.containerSelector
    ns.container.find(ns.removeSelector).each ->
      ns.bindRemoveButton @
    ns.bindAddButton()