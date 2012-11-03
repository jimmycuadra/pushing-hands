#= require ./vendor/underscore
#= require ./vendor/backbone
#= require hamlcoffee
#= require core
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./templates
#= require_tree ./views

class ph.GameSFX
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

class ph.Application
  constructor: (rowCount, columnCount) ->
    @setUpGrid(rowCount, columnCount)
    @setUpSounds()
    @setUpHUD()

  setUpGrid: (rowCount, columnCount) ->
    rows = @generateRows(rowCount, columnCount)
    @grid = new ph.CellRowsView(rows: rows)
    @grid.render()

  setUpSounds: ->
    @music = new ph.MusicPlayer {}, collection: new ph.Sounds [
        new ph.Sound(name: "relaxing", music: true)
        new ph.Sound(name: "tense", music: true)
      ]
    @sfx = new ph.Sounds [
        new ph.Sound(name: "push")
        new ph.Sound(name: "match")
        new ph.Sound(name: "fill")
      ]

  setUpHUD: ->
    @stats = new ph.StatsView
    @musicPlayer = new ph.MusicPlayerView(model: @music)

    hud = $("#hud")
    hud.append(@stats.render().el)
    hud.append(@musicPlayer.render().el)

  generateRows: (rowCount, columnCount) ->
    upperNeighbors = []

    rows = for i in [0...rowCount]
      collection = for j in [0...columnCount]
        if i > 0
          upperNeighbor = upperNeighbors[j]
        upperNeighbors[j] = new ph.Cell(upperNeighbor: upperNeighbor)
      new ph.CellRow(collection)

_.extend(ph.Application.prototype, Backbone.Events)

$ ->
  ph.app = new ph.Application(10, 10)
