# custom fields for credentials
# label, property(from API call), type('text','number'...), isProtected(true|false)


defaultFields = [
  [ 'Host name', 'host']
  [ 'Port', 'port', 'number']
  [ 'Username', 'user']
  [ 'Password', 'password', 'password', true]
  [ 'Database Name', 'database', 'text']
]

fields =
  'wr-db-oracle': [
    [ 'Host name', 'host']
    [ 'Port', 'port', 'number']
    [ 'Username', 'user']
    [ 'Password', 'password', 'password', true]
    [ 'Service Name/SID', 'database', 'text']
  ]

  'wr-db-redshift': [
        [ 'Host name', 'host']
        [ 'Port', 'port', 'number']
        [ 'Username', 'user']
        [ 'Password', 'password', 'password', true]
        [ 'Database Name', 'database', 'text']
        [ 'Schema', 'schema', 'text']
    ]


module.exports = (componentId) ->
  fields[componentId] or defaultFields
