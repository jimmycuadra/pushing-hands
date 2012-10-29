class PH.CellView extends Backbone.View
  template: JST.cell

  initialize: ->
    @model.on("change:color", @changeColor, this)

  changeColor: ->
    console.log(arguments)
