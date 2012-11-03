class ph.StatsView extends Backbone.View
  className: "well"

  template: JST.stats

  render: ->
    @$el.html(@template({}))
    this
