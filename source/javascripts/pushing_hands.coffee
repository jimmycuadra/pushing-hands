class PushingHands
  constructor: ->
    @cellCache = []
    @colors = ["r", "g", "b", "o"]
    @initializeCells()
    $(".hands").on("click", "div", @clickedHand)

  initializeCells: ->
    CELLS_PER_ROW = $("tr").first().children().length

    $("td").each (index, element) =>
      # Which row is the cell in?
      row = Math.floor(index / CELLS_PER_ROW)

      # Which column is the cell in?
      column = index % CELLS_PER_ROW

      # Pick a random color for the cell, excluding the color of the cell
      # directly above this one, if present.
      possibleColors = @colors.slice()
      cellAbove = @getCell(row - 1, column)
      if cellAbove
        possibleColors = _.difference(possibleColors, [cellAbove.color])
      color = possibleColors[Math.floor(Math.random() * possibleColors.length)]

      # Initialize and cache the cell
      @cellCache[row] = @cellCache[row] || []
      @cellCache[row][column] = new Cell($(element), color)

  getCell: (row, column) ->
    @cellCache[row] and @cellCache[row][column]

  getRow: (row) ->
    @cellCache[row]

  clickedHand: (event) =>
    row = $(event.target).index()
    direction = if $(event.delegateTarget).hasClass("flip")
      "left"
    else
      "right"
    @pushRow(row, direction)

  pushRow: (row, direction) ->
    cells = @getRow(row)
    if direction is "left"
      cells = Array::reverse.call(cells.slice())
    nextColor = cells[cells.length - 1].color

    _.each cells, (cell, index) =>
      newColor = nextColor
      nextColor = cell.color
      cell.color = newColor
