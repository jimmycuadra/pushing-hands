class ph.StatsView extends Backbone.View
  template: JST.stats

  render: ->
    @$el.html(@template({}))
    this
