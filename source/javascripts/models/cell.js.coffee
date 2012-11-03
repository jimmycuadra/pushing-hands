class ph.Cell extends Backbone.Model
  @COLORS = ["r", "g", "b", "o"]

  initialize: ->
    colors = @constructor.COLORS.slice()
    upperNeighbor = @get("upperNeighbor")
    if upperNeighbor
      colors = _.difference(colors, [upperNeighbor.get("color")])
    index = Math.floor(Math.random() * colors.length)
    @set("color", colors[index])
