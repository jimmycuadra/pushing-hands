class ph.Store extends Backbone.Model
  defaults:
    highScore: 0
    gamesPlayed: 0
    totalTime: 0
    allTimeChain: 0
    autoPlayMusic: true
    playSoundEffects: true
    colorblind: false

  initialize: ->
    @set
      score: 0
      currentTime: 0
      chain: 0
      gamesPlayed: @get("gamesPlayed") + 1

    @on("change:score", @checkHighScore, this)
    @on("change:chain", @checkChain, this)
    @on("change", @persist, this)

    @timer = new Timer
    @timer.every(100, @addTick)
    @timer.start()

  checkHighScore: (store, newScore) ->
    @set("highScore", newScore) if newScore > @get("highScore")

  checkChain: (store, newChain) ->
    @set("allTimeChain", newChain) if newChain > @get("allTimeChain")

  persist: (store) ->
    amplify.store("pushing-hands", @toJSON())

  toggleAutoPlay: ->
    @set(autoPlayMusic: !@get("autoPlayMusic"))

  toggleSoundEffects: ->
    @set(playSoundEffects: !@get("playSoundEffects"))

  toggleColorBlind: ->
    @set(colorblind: !@get("colorblind"))

  resetStats: ->
    if confirm "Are you sure you want to permanently reset your stats?"
      @timer.reset()
      @set
        score: 0
        highScore: 0
        chain: 0
        allTimeChain: 0
        currentTime: 0
        totalTime: 0
        gamesPlayed: 1
      @timer.start()

  addTick: =>
    ticks = @timer.ticks()
    @set(currentTime: ticks, totalTime: @get("totalTime") + 1)
