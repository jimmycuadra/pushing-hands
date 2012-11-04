class ph.StatsView extends Backbone.View
  className: "well"

  template: JST.stats

  initialize: ->
    @store = @options.store
    @store.on("change", @render, this)

  render: ->
    @$el.html(@template(@store.toJSON()))
    this
