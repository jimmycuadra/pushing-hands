class ph.Grid extends Backbone.Model
  initialize: (attributes, options) ->
    {@rowCount, @columnCount, app} = options
    {@sfx, @store} = app

    @cellRowsView = new ph.CellRowsView
      rows: @generateRows()
      sfx: @sfx
      grid: this
      store: @store

    @cellRowsView.render()

  generateRows: ->
    upperNeighbors = []

    rows = for i in [0...@rowCount]
      collection = for j in [0...@columnCount]
        if i > 0
          upperNeighbor = upperNeighbors[j]
        upperNeighbors[j] = new ph.Cell(upperNeighbor: upperNeighbor)
      new ph.CellRow(collection)

  markableRows: ->
    @cellRowsView.rows[0..(@cellRowsView.rows.length - 3)]

  markMatches: (chain = 1) ->
    score = 0
    marked = []

    for row, rowIndex in @markableRows()
      for cell, columnIndex in row.models
        tempMarked = [cell]
        color = cell.get("color")
        i = 1
        nextRow = @cellRowsView.rows[rowIndex + i]
        break unless nextRow
        nextCell = nextRow.at(columnIndex)
        while nextCell.get("color") is color
          tempMarked.push(nextCell)
          i++
          nextRow = @cellRowsView.rows[rowIndex + i]
          break unless nextRow
          nextCell = nextRow.at(columnIndex)
        if tempMarked.length >= 3
          marked.push.apply(marked, tempMarked)
          score += (3 + (tempMarked.length - 3) * 2) * chain

    if score is 0
      @set("locked", false)
      return

    @updateStats score, chain, =>
      @clear marked, =>
        @refill =>
          @markMatches(chain + 1)

  updateStats: (score, chain, callback) ->
    @store.set("score", @store.get("score") + score)
    @store.set("chain", chain) if chain > @store.get("chain")

    setTimeout(callback, 250)

  clear: (marked, callback) =>
    @sfx.play("match")

    _.each marked, (cell) ->
      cell.clear()

    setTimeout(callback, 250)

  refill: (callback) ->
    @sfx.play("fill")

    _.each @cellRowsView.rows.slice().reverse(), (row) ->
      row.refill()

    setTimeout(callback, 250)
