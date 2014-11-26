React = require 'react'
Router = require 'react-router'
routes = require './routes.coffee'

ApplicationActionCreators = require './actions/ApplicationActionCreators.coffee'
NoTokenPage = require './components/debug/NoTokenPage.coffee'


getParameterByName = (name, searchString) ->
  name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")
  regex = new RegExp("[\\?&]" + name + "=([^&#]*)")
  results = regex.exec(searchString)
  (if not results? then "" else decodeURIComponent(results[1].replace(/\+/g, " ")))



token = getParameterByName('token', window.location.search)
if !token
  React.render(React.createElement(NoTokenPage), document.getElementById 'react')
  return

ApplicationActionCreators.applicationDataReceived(
  sapiToken:
    token: token
)

Router.run routes, Router.HashLocation, (Handler, state) ->
  React.render(React.createElement(Handler), document.getElementById 'react')