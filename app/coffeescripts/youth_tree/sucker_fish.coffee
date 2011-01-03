YouthTree.withNS 'SuckerFish', (ns) ->
  ns.navigationSelector = "#page-header nav ul li"
  
  ns.setup = ->
    $(ns.navigationSelector).hover((-> $(@).addClass('sfhover')), (-> $(@).removeClass('sfhover')))
  