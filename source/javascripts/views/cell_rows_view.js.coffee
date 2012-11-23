class ph.CellRowsView extends Backbone.View
  initialize: ->
    {@rows, @sfx, @grid} = @options

    @setElement($("#grid"))

    @grid.on("change:locked", @toggleLock, this)

  render: =>
    _.each @rows, (row) =>
      view = new ph.CellRowView
        collection: row
        sfx: @sfx
        grid: @grid
      @$el.append(view.render().el)
    this

  toggleLock: (model, isLocked) ->
    if isLocked
      @$el.addClass("locked")
    else
      @$el.removeClass("locked")
