class ph.SettingsView extends Backbone.View
  className: "well"

  template: JST.settings

  events:
    "click #autoplay": "toggleAutoPlay"
    "click #sfx": "toggleSoundEffects"
    "click #reset": "resetStats"
    "click #colorblind": "toggleColorBlind"

  initialize: ->
    @model.on("change", @render, this)

  render: ->
    @$el.html(@template(@model.toJSON()))
    this

  toggleAutoPlay: (event) ->
    @model.toggleAutoPlay()

  toggleSoundEffects: (event) ->
    @model.toggleSoundEffects()

  resetStats: (event) ->
    event.preventDefault()
    @model.resetStats()

  toggleColorBlind: (event) ->
    console.log(event)
    @model.toggleColorBlind()
