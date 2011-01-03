YouthTree.withNS 'Carousel', (ns) ->

  ns.carouselSelector  = '#carousel'
  ns.containerSelector = 'ul'
  ns.elementSelector   = 'li'
  ns.carousels         = []
  ns.delay             = 5000
  
  class Carousel
    
    constructor: (@carousel) ->
      @index     = 0
      @container = @carousel.find ns.containerSelector
      @elements  = @container.find ns.elementSelector
      @count     = @elements.size()
      @elements.hover((=> @pause()), (=> @schedule()))
      @schedule()
      
    schedule: ->
      @timeout = setTimeout((=> @next()), ns.delay)
      
    pause: ->
      if @timeout?
        clearTimeout @timeout
        delete @timeout
      
    next: ->
      old_index = @index++
      @index = (@index % @count)
      
      from = @elements.filter ":eq(#{old_index})"
      to   = @elements.filter ":eq(#{@index})"
      
      from.fadeOut "slow"
      to.fadeIn "slow"
      
      @schedule() if @timeout?
      
  ns.setup = ->
    $(ns.carouselSelector).each ->
      ns.carousels.push new Carousel $(@)