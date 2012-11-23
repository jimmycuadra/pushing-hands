class ph.CellView extends Backbone.View
  tagName: "td"

  initialize: ->
    {@store} = @options

    @model.on("change", @render, this)
    @store.on("change:colorblind", @render, this)

  render: ->
    color = @model.get("color")
    @$el.removeClass().addClass(color)

    if @store.get("colorblind") and color
      @$el.html(@model.constructor.SYMBOLS[color])
    else
      @$el.html("")

    this
