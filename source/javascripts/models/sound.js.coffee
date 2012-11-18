class ph.Sound extends Backbone.Model
  defaults:
    state: "paused"

  initialize: ->
    @_audio = document.getElementById(@get("name"))
    @_audio.addEventListener("ended", @ended)
    @_audio.addEventListener("pause", @stateChanged)
    @_audio.addEventListener("play", @stateChanged)

  ended: (event) =>
    @trigger("ended")

  stateChanged: (event) =>
    if @_audio.paused
      @set(state: "paused")
    else
      @set(state: "playing")

  isPlaying: ->
    !@isPaused()

  isPaused: ->
    @get("state") is "paused"

  play: ->
    @_audio.play()

  pause: ->
    @_audio.pause()

  reset: ->
    @pause()
    @_audio.currentTime = 0
