#= require underscore
#= require backbone
#= require hamlcoffee
#= require_tree ./templates

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
    ph.trigger("sfx", "push")

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

class StatsView extends Backbone.View
  template: JST.stats

  render: ->
    @$el.html(@template({}))
    this

class MusicPlayerView extends Backbone.View
  template: JST.music_player

  events:
    "click button": "togglePlay"

  initialize: (options) ->
    @music = options.music
    @music.on("togglePlay", @render, this)

  render: ->
    @$el.html(@template(this))
    this

  togglePlay: (event) =>
    if @music.isPaused()
      @music.play()
    else
      @music.pause()

class GameMusic
  constructor: (ids) ->
    @currentIndex = 0
    @clips = for id in ids
      clip = document.getElementById(id)
      clip.volume = 0.3
      clip.addEventListener("ended", @playNext)
      clip

  play: ->
    @clips[@currentIndex].play()
    @trigger("togglePlay")

  pause: ->
    @clips[@currentIndex].pause()
    @trigger("togglePlay")

  playNext: =>
    @pause()
    @currentIndex++
    @currentIndex = 0 if @currentIndex >= @clips.length
    @play()

  isPaused: ->
    @clips[@currentIndex].paused

_.extend(GameMusic.prototype, Backbone.Events)

class GameSFX
  constructor: (ids) ->
    @clips = {}
    for id in ids
      @clips[id] = document.getElementById(id)

  trigger: (sfx) =>
    clip = @clips[sfx]
    unless clip.paused
      clip.pause()
      clip.currentTime = 0
    clip.play()

class Application
  constructor: (rowCount, columnCount) ->
    rows = @generateRows(rowCount, columnCount)
    @grid = new CellRowsView(rows: rows)

    @music = new GameMusic(["relaxing", "tense"])
    @sfx = new GameSFX(["push", "match", "fill"])
    @on("sfx", @sfx.trigger)

    hud = $("#hud")
    @stats = new StatsView
    @musicPlayer = new MusicPlayerView(music: @music)

    @grid.render()
    hud.append(@stats.render().el)
    hud.append(@musicPlayer.render().el)
    @music.play()

  generateRows: (rowCount, columnCount) ->
    upperNeighbors = []

    rows = for i in [0...rowCount]
      collection = for j in [0...columnCount]
        if i > 0
          upperNeighbor = upperNeighbors[j]
        upperNeighbors[j] = new Cell(upperNeighbor: upperNeighbor)
      new CellRow(collection)

_.extend(Application.prototype, Backbone.Events)

$ ->
  window.ph = new Application(10, 10)
