React = require 'react'
{table, tr, td, th, thead, tbody, span, div, a, p, h3} = React.DOM
ApplicationStore = require '../../../../../stores/ApplicationStore'

module.exports = React.createClass
  displayName: 'AppItem'
  propTypes:
    app: React.PropTypes.object.isRequired

  appUrl: ->
    "#{ApplicationStore.getProjectBaseUrl()}/application?app=#{@props.app.ui}"
  goToApp: ->
    window.location.href = @appUrl()

  render: ->
    (div className: 'col-sm-4', onClick: @goToApp,
      (div className: 'panel panel-default kb-component-panel kb-pointer',
        (div className: 'panel-body text-center',
          (h3 null,@props.app.name)
          (p null, @props.app.description)
          (a {href: @appUrl(), className: 'btn btn-primary btn-small'}, 'Go to App')
        )
      )
    )
