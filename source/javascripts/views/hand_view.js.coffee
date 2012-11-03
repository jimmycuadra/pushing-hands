class ph.HandView extends Backbone.View
  className: "hand"

  events:
    "click": "clickedHand"

  initialize: ->
    @cells = @options.cells
    @flip = !!@options.flip

  render: ->
    if @flip
      @$el.addClass("flip")
    this

  clickedHand: (event) ->
    @cells.trigger("push", @flip)
