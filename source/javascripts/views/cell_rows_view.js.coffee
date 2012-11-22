class ph.CellRowsView extends Backbone.View
  initialize: ->
    @rows = @options.rows
    @setElement($("#grid"))

  render: ->
    _.each @rows, (row) =>
      view = new ph.CellRowView(collection: row)
      @$el.append(view.render().el)
    this

  refill: ->
    _.each @rows.slice().reverse(), (row) ->
      row.refill()
