class ph.StatsView extends Backbone.View
  className: "span6"

  template: JST.stats

  render: ->
    @$el.html(@template({}))
    this
