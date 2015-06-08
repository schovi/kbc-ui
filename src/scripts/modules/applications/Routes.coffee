React = require 'react'
Index = require './react/pages/apps-index/AppsIndex'
installedComponentsActions =  require '../components/InstalledComponentsActionCreators'
installedComponentsStore =  require '../components/stores/InstalledComponentsStore'

routes =
  name: 'applications'
  title: 'Applications'
  defaultRouteHandler: Index


module.exports = routes
