window.ph = {}

HAML.globals = ->
  {
    formatTime: (ticks) ->
      hours = parseInt(ticks / 3600)
      minutes = parseInt((ticks / 60) % 60)
      seconds = ticks % 60

      minutes = "0#{minutes}" if minutes < 10
      seconds = "0#{seconds}" if seconds < 10

      "#{hours}:#{minutes}:#{seconds}"
  }
