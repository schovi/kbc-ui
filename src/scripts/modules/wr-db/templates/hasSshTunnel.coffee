componentsWithSshTunnel = ['keboola.wr-redshift-v2']
module.exports = (componentId) ->
  componentId in componentsWithSshTunnel
