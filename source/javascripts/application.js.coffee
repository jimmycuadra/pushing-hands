#= require underscore
#= require backbone

class Cell extends Backbone.Model
  @COLORS = ["r", "g", "b", "o"]

  initialize: ->
    colors = @constructor.COLORS.slice()
    upperNeighbor = @get("upperNeighbor")
    if upperNeighbor
      colors = _.difference(colors, [upperNeighbor.get("color")])
    index = Math.floor(Math.random() * colors.length)
    @set("color", colors[index])

class CellRow extends Backbone.Collection
  model: Cell

class CellRowsView extends Backbone.View
  initialize: ->
    @rows = @options.rows
    @setElement($("#grid"))

  render: ->
    _.each @rows, (row) =>
      view = new CellRowView(collection: row)
      @$el.append(view.render().el)
    this

class CellRowView extends Backbone.View
  tagName: "tr"

  initialize: ->
    @collection.on("push", @push, this)

  render: ->
    leftHandView = new HandView(cells: @collection)
    @$el.append(leftHandView.render().el)

    @collection.each (cell) =>
      view = new CellView(model: cell)
      @$el.append(view.render().el)

    rightHandView = new HandView(cells: @collection, flip: true)
    @$el.append(rightHandView.render().el)
    this

  push: (flip) ->
    models = @collection.models
    if flip
      models = Array::reverse.call(models.slice())
    nextColor = models[models.length - 1].get("color")
    _.each models, (cell) =>
      newColor = nextColor
      nextColor = cell.get("color")
      cell.set("color", newColor)


class CellView extends Backbone.View
  tagName: "td"

  initialize: ->
    @model.on("change", @render, this)

  render: ->
    @$el.removeClass().addClass(@model.get("color"))
    this

class HandView extends Backbone.View
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

class Application
  constructor: (rowCount, columnCount) ->
    rows = @generateRows(rowCount, columnCount)
    @grid = new CellRowsView(rows: rows)
    @grid.render()

  generateRows: (rowCount, columnCount) ->
    upperNeighbors = []

    rows = for i in [0...rowCount]
      collection = for j in [0...columnCount]
        if i > 0
          upperNeighbor = upperNeighbors[j]
        upperNeighbors[j] = new Cell(upperNeighbor: upperNeighbor)
      new CellRow(collection)

$ ->
  window.ph = new Application(10, 10)
