#= require underscore
#= require backbone
#= require hamlcoffee
#= require core
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./templates
#= require_tree ./views

class ph.GameMusic
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

_.extend(ph.GameMusic.prototype, Backbone.Events)

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
    rows = @generateRows(rowCount, columnCount)
    @grid = new ph.CellRowsView(rows: rows)

    @music = new ph.GameMusic(["relaxing", "tense"])
    @sfx = new ph.GameSFX(["push", "match", "fill"])
    @on("sfx", @sfx.trigger)

    hud = $("#hud .row-fluid")
    @stats = new ph.StatsView
    @musicPlayer = new ph.MusicPlayerView(music: @music)

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
        upperNeighbors[j] = new ph.Cell(upperNeighbor: upperNeighbor)
      new ph.CellRow(collection)

_.extend(ph.Application.prototype, Backbone.Events)

$ ->
  ph.app = new ph.Application(10, 10)
