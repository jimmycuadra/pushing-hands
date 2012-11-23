class ph.CellRowsView extends Backbone.View
  initialize: ->
    {@rows, @sfx, @grid, @store} = @options

    @setElement($("#grid"))

    @toggleColorBlindMode(this, @store.get("colorblind"))

    @grid.on("change:locked", @toggleLock, this)
    @store.on("change:colorblind", @toggleColorBlindMode, this)

  render: =>
    _.each @rows, (row) =>
      view = new ph.CellRowView
        collection: row
        sfx: @sfx
        grid: @grid
        store: @store
      @$el.append(view.render().el)
    this

  toggleLock: (model, isLocked) ->
    if isLocked
      @$el.addClass("locked")
    else
      @$el.removeClass("locked")

  toggleColorBlindMode: (model, isColorBlindMode) ->
    if isColorBlindMode
      @$el.addClass("colorblind")
    else
      @$el.removeClass("colorblind")
