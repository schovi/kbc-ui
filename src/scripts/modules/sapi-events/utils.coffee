


_classMap =
  error: 'danger'
  warn: 'warning'
  success: 'success'

module.exports =

  classForEventType: (eventType) ->
    _classMap[eventType]
