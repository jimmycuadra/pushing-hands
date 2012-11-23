class ph.Grid
  constructor: (options) ->
    {@rowCount, @columnCount, @app} = options

    @cellRowsView = new ph.CellRowsView(rows: @generateRows())
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
      return
    else
      @updateStats(score, chain)
      @clear(marked)
      setTimeout(
        =>
          @refill()
          setTimeout(
            =>
              @markMatches(chain + 1)
            200
          )
        200
      )

  updateStats: (score, chain) ->
    @app.store.set("score", @app.store.get("score") + score)
    @app.store.set("chain", chain) if chain > @app.store.get("chain")

  clear: (marked) =>
    @app.sfx.trigger("play", "match")

    _.each marked, (cell) ->
      cell.clear()

  refill: ->
    @app.sfx.trigger("play", "fill")

    _.each @cellRowsView.rows.slice().reverse(), (row) ->
      row.refill()
