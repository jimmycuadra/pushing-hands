class ph.Store extends Backbone.Model
  defaults:
    highScore: 0
    gamesPlayed: 0
    totalTime: 0
    autoPlayMusic: true
    playSoundEffects: true

  initialize: ->
    @set(currentTime: 0)
    @on("change", @persist, this)
    @timer = new Timer
    @timer.every(1, @addTick)
    @timer.start()

  persist: (store) ->
    amplify.store("pushing-hands", @toJSON())

  toggleAutoPlay: ->
    @set(autoPlayMusic: !@get("autoPlayMusic"))

  toggleSoundEffects: ->
    @set(playSoundEffects: !@get("playSoundEffects"))

  resetStats: ->
    if confirm "Are you sure you want to permanently reset your stats?"
      @timer.reset()
      @set(highScore: 0, gamesPlayed: 0, currentTime: 0, totalTime: 0)
      @timer.start()

  addTick: =>
    ticks = @timer.ticks()
    @set(currentTime: ticks, totalTime: @get("totalTime") + 1)
