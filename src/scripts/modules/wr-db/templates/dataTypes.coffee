### defulat defined in .../wr-db/react/pages/table.coffee
defaultDataTypes =
['INT','BIGINT',
'VARCHAR': {defaultSize: '255'},
'TEXT',
'DECIMAL': {defaultSize: '12,2'},
'DATE', 'DATETIME'
]
###

redshift = [
  'SMALLINT',
  'INTEGER',
  'BIGINT',
  'DECIMAL': {defaultSize: ''},
  'REAL',
  'DOUBLE PRECISION',
  'CHAR': {defaultSize: ''},
  'BOOLEAN',
  'VARCHAR': {defaultSize: ''},
  'DATE',
  'TIMESTAMP']

mssql = [
  'int', 'smallint', 'bigint', 'money',
  'decimal': {defaultSize: ''},
  'real', 'float': {defaultSize: ''},
  'date', 'datetime': {defaultSize: ''}, 'datetime2', 'time': {defaultSize: ''}, 'timestamp',
  'char': {defaultSize: ''}, 'varchar': {defaultSize: ''}, 'text',
  'nchar': {defaultSize: ''}, 'nvarchar': {defaultSize: ''}, 'ntext',
  'binary': {defaultSize: ''}, 'varbinary': {defaultSize: ''}, 'image',

  ]

module.exports =
'wr-db-mssql': mssql
'wr-db-redshift': redshift
'wr-db-oracle': ["char","nchar","varchar2","nvarchar",
"blob","clob","nclob","bfile","number","binary_float",
"binary_double","decimal","float","integer","date","timestamp",
"raw","rowid","urowid"]
