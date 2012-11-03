class ph.Sound extends Backbone.Model
  defaults:
    state: "paused"

  initialize: ->
    @_audio = document.getElementById(@get("name"))
    @_audio.addEventListener("ended", @stateChanged)
    @_audio.addEventListener("pause", @stateChanged)
    @_audio.addEventListener("play", @stateChanged)

  stateChanged: (event) =>
    if @_audio.paused
      @set(state: "paused")
    else
      @set(state: "playing")

  play: ->
    @_audio.play()

  pause: ->
    @_audio.pause()

  reset: ->
    @pause()
    @_audio.currentTime = 0
