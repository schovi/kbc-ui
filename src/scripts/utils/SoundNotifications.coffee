ApplicationStore = require '../stores/ApplicationStore'

paths =
  success: require '../../media/success.mp3'
  crash: require '../../media/crash.mp3'


soundElements = {}

getSoundElement = (name) ->
  if !soundElements[name]
    soundElements[name] = new Audio(paths[name])
  soundElements[name]

module.exports =
  success: ->
    getSoundElement('success').play()
  crash: ->
    getSoundElement('crash').play()
