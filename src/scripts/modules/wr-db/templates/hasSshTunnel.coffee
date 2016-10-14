componentsWithSshTunnel = ['keboola.wr-redshift-v2', 'keboola.wr-db-mssql-v2']
module.exports = (componentId) ->
  componentId in componentsWithSshTunnel
