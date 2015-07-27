module.exports =
  mysql:
    fieldsMapping:
      host: 'hostname'
      database: 'db'
      password: 'password'
      user: 'user'
    defaultPort: '3306'
  redshift:
    fieldsMapping:
      host: 'hostname'
      database: 'db'
      password: 'password'
      user: 'user'
      schema: 'schema'
    defaultPort: '5439'
