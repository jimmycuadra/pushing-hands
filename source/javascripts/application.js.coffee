#= require underscore
#= require backbone
#= require core
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./templates
#= require_tree ./views

class PH.Application
  constructor: ->
    rows = for i in [0...10]
      cells = for j in [0...10]
        new PH.Cell
      new PH.Cells(columns)
    @grid = new PH.Cells(rows)

$ ->
  PH.app = new PH.Application
