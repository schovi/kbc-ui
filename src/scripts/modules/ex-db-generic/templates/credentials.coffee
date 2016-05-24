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

COMPONENTS_FIELDS = {
  'keboola.ex-db-pgsql': defaultFields
  'keboola.ex-db-db2': defaultFields
  'keboola.ex-db-firebird': firebirdFields
  'keboola.ex-db-impala': defaultFields
  'keboola.ex-db-oracle': oracleFields
  'keboola.ex-mongodb': defaultFields
}


getFields = (componentId) ->
  return COMPONENTS_FIELDS[componentId] or defaultFields

module.exports =
  getFields: getFields

  # returns @array of properties that needs to be hashed
  # should return only password property in most cases
  getProtectedProperties: (componentId) ->
    result = []
    fields = getFields(componentId)
    for f in fields
      isProtected = f[3]
      propName = f[1]
      if isProtected
        result.push(propName)
    return result
