# custom fields for credentials
# label, property(from API call), type('text','number'...), isProtected(true|false)


defaultFields = [
  [ 'Host name', 'host']
  [ 'Port', 'port', 'number', false, '3306']
  [ 'Username', 'user']
  [ 'Password', 'password', 'password', true]
  [ 'Database Name', 'database', 'text']
]

fields =
  'wr-db-oracle': [
    [ 'Host name', 'host']
    [ 'Port', 'port', 'number', false, '1521']
    [ 'Username', 'user']
    [ 'Password', 'password', 'password', true]
    [ 'Service Name/SID', 'database', 'text']
  ]

  'wr-db-redshift': [
    [ 'Host name', 'host']
    [ 'Port', 'port', 'number', false, '5439']
    [ 'Username', 'user']
    [ 'Password', 'password', 'password', true]
    [ 'Database Name', 'database', 'text']
    [ 'Schema', 'schema', 'text']
  ]

  'wr-db-mssql': [
    [ 'Host name', 'host']
    [ 'Port', 'port', 'number', false, '1433']
    [ 'Username', 'user']
    [ 'Password', 'password', 'password', true]
    [ 'Database Name', 'database', 'text']
  ]

  'keboola.wr-db-mssql-v2': [
    [ 'Host name', 'host']
    [ 'Port', 'port', 'number', false, '1433']
    [ 'Username', 'user']
    [ 'Password', '#password', 'password', true]
    [ 'Database Name', 'database', 'text']
  ]

  'keboola.wr-db-mysql': [
    [ 'Host name', 'host']
    [ 'Port', 'port', 'number', false, '3306']
    [ 'Username', 'user']
    [ 'Password', '#password', 'password', true]
    [ 'Database Name', 'database', 'text']

  ]

  'keboola.wr-db-impala': [
    [ 'Host name', 'host']
    [ 'Port', 'port', 'number', false, '21050']
    [ 'Username', 'user']
    [ 'Password', '#password', 'password', true]
    [ 'Database Name', 'database', 'text']
    [ 'Authentication mechanism', 'auth_mech', 'number', false, '3']
  ]

  'keboola.wr-redshift-v2': [
    [ 'Host name', 'host']
    [ 'Port', 'port', 'number', false, '5439']
    [ 'Username', 'user']
    [ 'Password', '#password', 'password', true]
    [ 'Database Name', 'database', 'text']
    [ 'Schema', 'schema', 'text']
  ]

  'keboola.wr-db-oracle': [
    [ 'Host name', 'host']
    [ 'Port', 'port', 'number', false, '1521']
    [ 'Username', 'user']
    [ 'Password', '#password', 'password', true]
    [ 'Service Name/SID', 'database', 'text']
  ]


module.exports = (componentId) ->
  fields[componentId] or defaultFields
