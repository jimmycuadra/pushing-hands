class ph.MusicPlayerView extends Backbone.View
  className: "well"

  template: JST.music_player

  events:
    "click .prev": "clickedPrev"
    "click .next": "clickedNext"
    "click .toggle": "clickedToggle"

  initialize: ->
    @model.on("change:state", @render, this)

  render: ->
    @$el.html(@template(@model.toJSON()))
    this

  clickedPrev: (event) =>
    @model.prevTrack()

  clickedNext: (event) =>
    @model.nextTrack()

  clickedToggle: (event) =>
    @model.togglePlayback()
