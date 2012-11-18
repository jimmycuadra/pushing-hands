class ph.Store extends Backbone.Model
  defaults:
    highScore: 0
    gamesPlayed: 0
    totalTime: 0
    autoPlayMusic: true
    playSoundEffects: true

  initialize: ->
    @set
      score: 0
      currentTime: 0
      gamesPlayed: @get("gamesPlayed") + 1

    @on("change:score", @checkHighScore, this)
    @on("change", @persist, this)

    @timer = new Timer
    @timer.every(1, @addTick)
    @timer.start()

  checkHighScore: (store, newScore) ->
    @set("highScore", newScore) if newScore > @get("highScore")

  persist: (store) ->
    amplify.store("pushing-hands", @toJSON())

  toggleAutoPlay: ->
    @set(autoPlayMusic: !@get("autoPlayMusic"))

  toggleSoundEffects: ->
    @set(playSoundEffects: !@get("playSoundEffects"))

  resetStats: ->
    if confirm "Are you sure you want to permanently reset your stats?"
      @timer.reset()
      @set
        score: 0
        highScore: 0
        currentTime: 0
        totalTime: 0
        gamesPlayed: 1
      @timer.start()

  addTick: =>
    ticks = @timer.ticks()
    @set(currentTime: ticks, totalTime: @get("totalTime") + 1)
