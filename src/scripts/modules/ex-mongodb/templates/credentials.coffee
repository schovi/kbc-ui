# define as [labelValue, propName, type = 'text', isProtected = false]

defaultFields = [
  ['Host Name', 'host', 'text', false]
  ['Port', 'port', 'number', false]
  ['Username', 'user', 'text', false]
#  ['Password', 'password', 'password', true]
  ['Password', '#password', 'password', true]
  ['Database', 'database', 'text', false]
]

module.exports =
  getFields: (componentId) ->
    return defaultFields
