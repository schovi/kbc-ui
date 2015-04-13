ApplicationStore = require '../stores/ApplicationStore'

soundElements = {}

getSoundElement = (name) ->
  if !soundElements[name]
    soundElements[name] = new Audio(ApplicationStore.getScriptsBasePath() + "media/#{name}.mp3")
  soundElements[name]

module.exports =
  success: ->
    getSoundElement('success').play()
  crash: ->
    getSoundElement('crash').play()
