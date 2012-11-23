class ph.CellRowView extends Backbone.View
  tagName: "tr"

  initialize: ->
    {@sfx, @grid} = @options
    @collection.on("push", @push, this)

  render: ->
    leftHandView = new ph.HandView(cells: @collection)
    @$el.append(leftHandView.render().el)

    @collection.each (cell) =>
      view = new ph.CellView(model: cell)
      @$el.append(view.render().el)

    rightHandView = new ph.HandView(cells: @collection, flip: true)
    @$el.append(rightHandView.render().el)
    this

  push: (flip) ->
    return if @grid.get("locked")

    @grid.set("locked", true)

    models = if flip
      @collection.models.slice().reverse()
    else
      @collection.models

    nextColor = models[models.length - 1].get("color")
    _.each models, (cell) =>
      newColor = nextColor
      nextColor = cell.get("color")
      cell.set("color", newColor)

    @sfx.play("push")
    @grid.markMatches()
