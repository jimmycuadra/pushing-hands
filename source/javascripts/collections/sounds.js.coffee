class ph.Sounds extends Backbone.Collection
  model: ph.Sound

  initialize: ->
    @on("play", @play, this)

  play: (name) ->
    return unless ph.app.store.get("playSoundEffects")

    sounds = @where(name: name)
    _.each sounds, (sound) ->
      sound.reset() if sound.isPlaying()
      sound.play()
