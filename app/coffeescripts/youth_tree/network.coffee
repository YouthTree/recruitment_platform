YouthTree.withNS 'Network', (ns) ->
  
  ns.buttonSelector = '#yt-subscribe'
  ns.panelSelector  = '#yt-subscribe-panel'

  ns.showPanel = (link, e) ->
    e.preventDefault()
    $(link).addClass 'active'
    ns.panel.slideDown()
    
  ns.hidePanel = (link, e) ->
    e.preventDefault()
    $(link).removeClass 'active'
    ns.panel.slideUp()
    
  ns.wrapperFor = (f) ->
    (e) -> f @, e
  
  ns.setupSubscriptionToggler = ->
    ns.panel = $ ns.panelSelector
    $(ns.buttonSelector).toggle ns.wrapperFor(ns.showPanel), ns.wrapperFor(ns.hidePanel)
    
  ns.setup = ->
    ns.setupSubscriptionToggler()