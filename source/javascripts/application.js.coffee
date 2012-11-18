#= require ./vendor/underscore
#= require ./vendor/backbone
#= require ./vendor/amplify.store
#= require ./vendor/timer
#= require bootstrap-modal
#= require hamlcoffee
#= require core
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./templates
#= require_tree ./views

class ph.Application
  constructor: (rowCount, columnCount) ->
    @store = new ph.Store(amplify.store("pushing-hands"))
    @setUpGrid(rowCount, columnCount)
    @setUpSounds()
    @setUpHUD()
    @on("push", @markMatches)
    $("#loading").remove()

  setUpGrid: (rowCount, columnCount) ->
    rows = @generateRows(rowCount, columnCount)
    @grid = new ph.CellRowsView(rows: rows)
    @grid.render()

  setUpSounds: ->
    @music = new ph.MusicPlayer {}, collection: new ph.Sounds [
        new ph.Sound(name: "relaxing")
        new ph.Sound(name: "tense")
      ]
    @sfx = new ph.Sounds [
        new ph.Sound(name: "push")
        new ph.Sound(name: "match")
        new ph.Sound(name: "fill")
      ]
    @music.play() if @store.get("autoPlayMusic")

  setUpHUD: ->
    @stats = new ph.StatsView(store: @store)
    @musicPlayer = new ph.MusicPlayerView(model: @music)
    @settings = new ph.SettingsView(model: @store)

    hud = $("#hud")
    hud.append(@stats.render().el)
    hud.append(@musicPlayer.render().el)
    hud.append(@settings.render().el)

  generateRows: (rowCount, columnCount) ->
    upperNeighbors = []

    rows = for i in [0...rowCount]
      collection = for j in [0...columnCount]
        if i > 0
          upperNeighbor = upperNeighbors[j]
        upperNeighbors[j] = new ph.Cell(upperNeighbor: upperNeighbor)
      new ph.CellRow(collection)

  markMatches: ->
    marked = []

    for row, rowIndex in @grid.rows[0..@grid.rows.length - 3]
      for cell, columnIndex in row.models
        tempMarked = [cell]
        color = cell.get("color")
        i = 1
        nextCell = @grid.rows[rowIndex + i].at(columnIndex)
        while nextCell.get("color") is color
          tempMarked.push(nextCell)
          i++
          nextCell = @grid.rows[rowIndex + i].at(columnIndex)
        if tempMarked.length >= 3
          marked.push.apply(marked, tempMarked)

    _.each marked, (cell) ->
      cell.trigger("clear")

_.extend(ph.Application.prototype, Backbone.Events)

$ ->
  ph.app = new ph.Application(10, 10)
