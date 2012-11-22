class ph.Cell extends Backbone.Model
  @COLORS = ["r", "g", "b", "o"]

  @randomColor: ->
    @COLORS[_.random(0, @COLORS.length - 1)]

  initialize: ->
    colors = @constructor.COLORS.slice()
    upperNeighbor = @get("upperNeighbor")
    if upperNeighbor
      colors = _.difference(colors, [upperNeighbor.get("color")])
    index = Math.floor(Math.random() * colors.length)
    @set("color", colors[index])

    @on("clear", @clear)
    @on("refill", @refill)

  clear: =>
    @set("color", null)

  refill: =>
    upperNeighbor = @get("upperNeighbor")

    color = if upperNeighbor
      upperNeighbor.fallingBlockColor()
    else
      @constructor.randomColor()

    @set("color", color)

  fallingBlockColor: ->
    color = @get("color")
    upperNeighbor = @get("upperNeighbor")

    if color
      @clear()
      color
    else if upperNeighbor
      upperNeighbor.fallingBlockColor()
    else
      @constructor.randomColor()
