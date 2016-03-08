# define as [labelValue, propName, type = 'text', isProtected = false]

defaultFields = [
  ['Host Name', 'host', 'text', false]
  ['Port', 'port', 'number', false]
  ['Username', 'user', 'text', false]
  ['Password', 'password', 'password', true]
  ['Database', 'database', 'text', false]
]

firebirdFields = [
  ['Database', 'dbname', 'text', false]
  ['Username', 'user', 'text', false]
  ['Password', 'password', 'password', true]
]

fields =
  'keboola.ex-db-pgsql': defaultFields
  'keboola.ex-db-db2': defaultFields
  'keboola.ex-db-firebird': firebirdFields


module.exports =
  getFields: (componentId) ->
    return fields[componentId] or defaultFields
