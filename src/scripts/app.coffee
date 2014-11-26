React = require 'react'
Router = require 'react-router'
routes = require './routes.coffee'

ApplicationActionCreators = require './actions/ApplicationActionCreators.coffee'



ApplicationActionCreators.applicationDataReceived(
  sapiToken:
    token: ''
)

Router.run routes, Router.HistoryLocation, (Handler, state) ->
  console.log 'run', state
  React.render(React.createElement(Handler), document.getElementById 'react')