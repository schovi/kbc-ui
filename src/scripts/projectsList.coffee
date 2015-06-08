###
  Mock page for projects list development
  Not used in production

###

React = require 'react'
Immutable = require 'immutable'
{div, span} = React.DOM

CurrentUser = require './react/layout/CurrentUser'

App = React.createClass
  render: ->
    div className: 'kbc-outer-container',
      div className: 'kbc-outer-logo',
        span className: 'kbc-icon-keboola-logo'
        React.createElement CurrentUser,
          user: @props.user
          maintainers: @props.maintainers
          urlTemplates: @props.urlTemplates
          canManageApps: true
      div className: 'kbc-outer-content well',
        'todo'

global.kbcApp =
  start: (appOptions) ->
    console.log 'start list', appOptions
    document.body.className = 'kbc-outer-page kbc-projects-list'
    React.render(React.createElement(App,
      user: Immutable.fromJS(appOptions.data.kbc.admin)
      urlTemplates: Immutable.fromJS(appOptions.data.kbc.urlTemplates)
      maintainers: Immutable.fromJS(appOptions.data.maintainers)
    ), document.body)

  helpers: require './helpers'