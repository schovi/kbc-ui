# define as [labelValue, propName, type = 'text', isProtected = false]

defaultFields = [
  ['Host Name', 'host', 'text', false]
  ['Port', 'port', 'number', false]
  ['Username', 'user', 'text', false]
  ['Password', 'password', 'password', true]
  ['Database', 'database', 'text', false]
]


# impala fields:
# host: impala
# port: 21050
# database: default
# user: impala
# password:
# auth_mech: 0

firebirdFields = [
  ['Database', 'dbname', 'text', false]
  ['Username', 'user', 'text', false]
  ['Password', 'password', 'password', true]
]

oracleFields = [
  ['Host Name', 'host', 'text', false]
  ['Port', 'port', 'number', false]
  ['Username', 'user', 'text', false]
  ['Password', 'password', 'password', true]
  ['Service Name/SID', 'database', 'text', false]
]

fields =
  'keboola.ex-db-pgsql': defaultFields
  'keboola.ex-db-db2': defaultFields
  'keboola.ex-db-firebird': firebirdFields
  'keboola.ex-db-impala': defaultFields
  'keboola.ex-db-oracle': oracleFields


module.exports =
  getFields: (componentId) ->
    return fields[componentId] or defaultFields
