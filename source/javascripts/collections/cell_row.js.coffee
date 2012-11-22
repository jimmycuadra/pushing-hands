class ph.CellRow extends Backbone.Collection
  model: ph.Cell

  refill: ->
    @each (cell) ->
      cell.refill()
