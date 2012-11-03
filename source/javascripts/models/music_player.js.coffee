class ph.MusicPlayer extends Backbone.Model
  defaults:
    currentIndex: 0
    state: "paused"

  initialize: ->
    @collection.on("change:state", @stateChanged, this)

  stateChanged: (model, state, attributes) ->
    @set(state: state)

  currentTrack: ->
    @collection.at(@get("currentIndex"))

  isPaused: ->
    @get("state") is "paused"

  play: ->
    @currentTrack().play()

  pause: ->
    @currentTrack().pause()

  togglePlayback: ->
    if @isPaused()
      @play()
    else
      @pause()
