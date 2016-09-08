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
  'DECIMAL': {defaultSize: '12,2'},
  'REAL',
  'DOUBLE PRECISION',
  'CHAR': {defaultSize: '255'},
  'BOOLEAN',
  'VARCHAR': {defaultSize: '255'},
  'DATE',
  'TIMESTAMP']

mssql = [
  'bigint', 'money',
  'decimal': {defaultSize: '12,2'},
  'real', 'float': {defaultSize: '12'},
  'date', 'datetime': {defaultSize: 'YYYY-MM-DDThh:mm:ss[.mmm]'},
  'datetime2',
  'time': {defaultSize: '7'}, 'timestamp',
  'char': {defaultSize: '255'},
  'text', 'varchar': {defaultSize: '255'}, 'smallint',
  'nchar': {defaultSize: '255'}, 'int', 'nvarchar': {defaultSize: '255'}, 'ntext',
  'binary': {defaultSize: '1'}, 'image', 'varbinary': {defaultSize: '1'}

  ]

module.exports =
'keboola.wr-db-mssql-v2': mssql
'wr-db-mssql': mssql
'wr-db-redshift': redshift
'wr-db-oracle': ["char","nchar","varchar2","nvarchar",
"blob","clob","nclob","bfile","number","binary_float",
"binary_double","decimal","float","integer","date","timestamp",
"raw","rowid","urowid"]
