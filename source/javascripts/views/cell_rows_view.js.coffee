class ph.CellRowsView extends Backbone.View
  initialize: ->
    {@rows, @sfx, @grid} = @options
    @setElement($("#grid"))

  render: =>
    _.each @rows, (row) =>
      view = new ph.CellRowView
        collection: row
        sfx: @sfx
        grid: @grid
      @$el.append(view.render().el)
    this
