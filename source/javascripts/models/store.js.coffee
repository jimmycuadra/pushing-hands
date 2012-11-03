class ph.Store extends Backbone.Model
  defaults:
    highScore: 0
    gamesPlayed: 0
    autoPlayMusic: true
    playSoundEffects: true

  initialize: ->
    @on("change", @persist, this)

  persist: (store) ->
    amplify.store("pushing-hands", @toJSON())

  toggleAutoPlay: ->
    @set(autoPlayMusic: !@get("autoPlayMusic"))

  toggleSoundEffects: ->
    @set(playSoundEffects: !@get("playSoundEffects"))

  resetStats: ->
    if confirm "Are you sure you want to permanently reset your stats?"
      @set(highScore: 0, gamesPlayed: 0)
