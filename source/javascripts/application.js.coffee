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
    @grid = new ph.Grid
      rowCount: rowCount,
      columnCount: columnCount,
      app: this
    @setUpSounds()
    @setUpHUD()
    $("#loading").remove()

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

_.extend(ph.Application.prototype, Backbone.Events)

$ ->
  ph.app = new ph.Application(10, 10)
