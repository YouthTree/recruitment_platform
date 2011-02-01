RecruitmentPlatform.withNS 'Admin.TeamEditor', (ns) ->

  # Selectors for various things.
  ns.dialogSelector      = '#reorder-teams'
  ns.sortableSelector    = 'ol'
  ns.linkSelector        = '.reorder-teams-link'
  
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

