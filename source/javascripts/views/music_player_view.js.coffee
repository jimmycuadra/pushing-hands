class ph.MusicPlayerView extends Backbone.View
  template: JST.music_player

  events:
    "click button": "togglePlay"

  initialize: (options) ->
    @music = options.music
    @music.on("togglePlay", @render, this)

  render: ->
    @$el.html(@template(this))
    this

  togglePlay: (event) =>
    if @music.isPaused()
      @music.play()
    else
      @music.pause()
