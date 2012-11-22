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

  markMatches: (chain) ->
    chain or= 1
    score = 0
    marked = []

    for row, rowIndex in @cellRowsView.rows[0..(@cellRowsView.rows.length - 3)]
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

    return if score is 0

    @app.store.set("score", @app.store.get("score") + score)
    @app.store.set("chain", chain) if chain > @app.store.get("chain")

    # Clear matches

    @app.sfx.trigger("play", "match")
    _.each marked, (cell) ->
      cell.clear()

    # Refill cleared blocks

    @app.sfx.trigger("play", "fill")
    _.each @cellRowsView.rows.slice().reverse(), (row) ->
      row.refill()

    # Check for more matches

    @markMatches(chain + 1)
