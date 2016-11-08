componentsWithSshTunnel = ['keboola.wr-redshift-v2', 'keboola.wr-db-mssql-v2', 'keboola.wr-db-mysql',
'keboola.wr-db-impala', 'keboola.wr-db-oracle']
module.exports = (componentId) ->
  componentId in componentsWithSshTunnel
