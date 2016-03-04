# define as [labelValue, propName, type = 'text', isProtected = false]

defaultFields = [
  ['Host Name', 'host', 'text', false]
  ['Port', 'port', 'number', false]
  ['Username', 'user', 'text', false]
  ['Password', 'password', 'password', true]
  ['Database', 'database', 'text', false]
]


fields =
  'keboola.ex-db-pgsql': defaultFields


module.exports =
  getFields: (componentId) ->
    return fields[componentId] or defaultFields
