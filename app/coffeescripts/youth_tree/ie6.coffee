YouthTree.withNS 'IE6', (ns) ->
  
  ns.belatedPNGSelectors = [
    "#page-header h1 a"
    "ul#social-media-icons li a"
    "#yt-subscribe-button button"
    "#flash-messages p.flash"
  ]
  
  ns.setup = ->
    if DD_belatedPNG?
      $(ns.belatedPNGSelectors.join(", ")).each -> DD_belatedPNG.fixPng @