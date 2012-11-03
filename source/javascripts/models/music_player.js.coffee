class ph.MusicPlayer extends Backbone.Model
  defaults:
    currentIndex: 0
    state: "paused"

  initialize: ->
    @collection.on("change:state", @stateChanged, this)
    @collection.on("ended", @playNextTrack, this)

  stateChanged: (model, state, attributes) ->
    @set(state: state)

  playNextTrack: ->
    @nextTrack()
    @play()

  currentTrack: ->
    @collection.at(@get("currentIndex"))

  isPlaying: ->
    !@isPaused()

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

  prevTrack: ->
    shouldPlay = @isPlaying()
    @currentTrack().reset()
    index = @get("currentIndex")
    index -= 1
    index = @collection.length - 1 if index < 0
    @set(currentIndex: index)
    @play() if shouldPlay

  nextTrack: ->
    shouldPlay = @isPlaying()
    @currentTrack().reset()
    index = @get("currentIndex")
    index += 1
    index = 0 if index >= @collection.length
    @set(currentIndex: index)
    @play() if shouldPlay
