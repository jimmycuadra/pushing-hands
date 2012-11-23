class ph.Sounds extends Backbone.Collection
  model: ph.Sound

  initialize: (models, options) ->
    {@store} = options

  play: (name) ->
    return unless @store.get("playSoundEffects")

    sounds = @where(name: name)
    _.each sounds, (sound) ->
      sound.reset() if sound.isPlaying()
      sound.play()
