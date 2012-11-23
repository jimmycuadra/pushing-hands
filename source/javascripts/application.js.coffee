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

    @setUpSounds()

    @grid = new ph.Grid
      rowCount: rowCount
      columnCount: columnCount
      app: this

    @setUpHUD()

    $("#loading").remove()

  setUpSounds: ->
    music = new ph.Sounds [
      new ph.Sound(name: "relaxing")
      new ph.Sound(name: "tense")
    ],
    store: @store

    @musicPlayer = new ph.MusicPlayer({}, collection: music)

    @sfx = new ph.Sounds [
      new ph.Sound(name: "push")
      new ph.Sound(name: "match")
      new ph.Sound(name: "fill")
    ],
    store: @store

    @musicPlayer.play() if @store.get("autoPlayMusic")

  setUpHUD: ->
    @stats = new ph.StatsView(store: @store)

    @musicPlayerView = new ph.MusicPlayerView(model: @musicPlayer)

    @settings = new ph.SettingsView(model: @store)

    hud = $("#hud")
    hud.append(@stats.render().el)
    hud.append(@musicPlayerView.render().el)
    hud.append(@settings.render().el)

_.extend(ph.Application.prototype, Backbone.Events)

$ ->
  ph.app = new ph.Application(10, 10)
