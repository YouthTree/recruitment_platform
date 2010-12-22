RecruitmentPlatform.withNS 'Admin.PaidField', (ns) ->

  ns.paidSelector       = '#position_paid'
  ns.payDetailsSelector = '#position_paid_description_input'

  ns.updateFieldState = ->
    if ns.isPaid()
      ns.payDetails.show()
    else
      ns.payDetails.hide()

  ns.isPaid = ->
    ns.payField.is ':checked'

  ns.setup = ->
    ns.payDetails = $ ns.payDetailsSelector
    ns.payField   = $ ns.paidSelector
    ns.payField.change(-> ns.updateFieldState()).change()