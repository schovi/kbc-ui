index = require './react/pages/Index/Index'

module.exports =
  name: 'tde-exporter'
  path: 'tde-exporter/:config'
  defaultRouteHandler: index
  isComponent: true
