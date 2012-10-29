#= require underscore
#= require backbone

class window.Cell extends Backbone.Model
  @COLORS = ["r", "g", "b", "o"]

  initialize: ->
    unless @get("color")
      index = Math.floor(Math.random() * @constructor.COLORS.length)
      @set("color", @constructor.COLORS[index])

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
    @collection.each (cell) =>
      view = new CellView(model: cell)
      @$el.append(view.render().el)
    this

class CellView extends Backbone.View
  tagName: "td"

  render: ->
    @$el.addClass(@model.get("color"))
    this

class Application
  constructor: (rowCount, columnCount) ->
    rows = for i in [0...rowCount]
      collection = for j in [0...columnCount]
        new Cell
      new CellRow(collection)

    @grid = new CellRowsView(rows: rows)
    @grid.render()

$ ->
  window.ph = new Application(10, 10)
