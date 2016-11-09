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
  'bigint',
  'uniqueidentifier': {defaultSize: '36'},
  'money',
  'decimal': {defaultSize: '12,2'},
  'real', 'float': {defaultSize: '12'},
  'date', 'datetime', 'smalldatetime',
  'datetime2',
  'time': {defaultSize: '7'}, 'timestamp',
  'char': {defaultSize: '255'},
  'text', 'varchar': {defaultSize: '255'}, 'smallint',
  'nchar': {defaultSize: '255'}, 'int', 'nvarchar': {defaultSize: '255'}, 'ntext',
  'binary': {defaultSize: '1'}, 'image', 'varbinary': {defaultSize: '1'}

  ]
impala = [
  'bigint', 'boolean', 'char': {defaultSize: '255'},
  'double', 'decimal': {defaultSize: '9,0'}, 'float', 'int', 'real',
  'smallint', 'string', 'timestamp',
  'tinyint', 'varchar': {defaultSize: '255'}
]
oracleold = [
  'char', 'nchar', 'varchar2', 'nvarchar',
  'blob', 'clob', 'nclob', 'bfile', 'number', 'binary_float',
  'binary_double', 'decimal', 'float', 'integer', 'date', 'timestamp',
  'raw', 'rowid', 'urowid'
]
oracle = [
  'bfile'
  'binary_float'
  'binary_double'
  'blob'
  {'char': defaultSize: '255'}
  'clob'
  'date'
  {'nchar': defaultSize: '255'}
  'nclob'
  {'nvarchar2': defaultSize: '255'}
  {'number': defaultSize: '12,2'}
  {'raw': defaultSize: '255'}
  'rowid'
  'timestamp'
  'urowid'
  {'varchar2': defaultSize: '255'}
]

module.exports =
'keboola.wr-db-oracle': oracle
'keboola.wr-db-impala': impala
'keboola.wr-db-mssql-v2': mssql
'wr-db-mssql': mssql
'keboola.wr-redshift-v2': redshift
'wr-db-redshift': redshift
'wr-db-oracle': oracleold
