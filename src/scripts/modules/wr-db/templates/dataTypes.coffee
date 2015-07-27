### defulat defined in .../wr-db/react/pages/table.coffee
defaultDataTypes =
['INT','BIGINT',
'VARCHAR': {defaultSize: '255'},
'TEXT',
'DECIMAL': {defaultSize: '12,2'},
'DATE', 'DATETIME'
]
###



module.exports =
  'wr-db-oracle': ["char","nchar","varchar2","nvarchar",
  "blob","clob","nclob","bfile","number","binary_float",
  "binary_double","decimal","float","integer","date","timestamp",
  "raw","rowid","urowid"]
