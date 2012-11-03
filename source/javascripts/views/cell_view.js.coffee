class ph.CellView extends Backbone.View
  tagName: "td"

  initialize: ->
    @model.on("change", @render, this)

  render: ->
    @$el.removeClass().addClass(@model.get("color"))
    this
