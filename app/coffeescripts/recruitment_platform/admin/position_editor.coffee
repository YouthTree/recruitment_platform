RecruitmentPlatform.withNS 'Admin.PositionEditor', (ns) ->

  # Selectors for various things.
  ns.dialogSelector      = '#reorder-positions'
  ns.sortableSelector    = 'ol'
  ns.linkSelector        = '.reorder-positions-link'
  
  sortable = false
  
  ns.showReorderDialog = ->
    ns.makeSortable()
    $(ns.dialogSelector).dialog()
  
  ns.makeSortable = ->
    return if sortable
    container = $("#{ns.dialogSelector} #{ns.sortableSelector}")
    container.sortable()
    container.disableSelection()
    sortable = true
  
  ns.bindReorderButton = ->
    $(ns.linkSelector).click ->
      ns.showReorderDialog()
      false
  
  ns.setup = -> ns.bindReorderButton()
