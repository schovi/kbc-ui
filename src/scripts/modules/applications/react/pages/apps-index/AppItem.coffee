React = require 'react'
{span, div, a, p, h2} = React.DOM
ApplicationStore = require '../../../../../stores/ApplicationStore'

module.exports = React.createClass
  displayName: 'AppItem'
  propTypes:
    app: React.PropTypes.object.isRequired

  appUrl: ->
    "#{ApplicationStore.getProjectBaseUrl()}/application?app=#{@props.app.get('ui')}"

  render: ->
    div className: 'col-sm-4',
      div className: 'panel',
        div className: 'panel-body text-center',
          h2 null, @props.app.get 'name'
          p null, @props.app.get 'description'
          a
            className: 'btn btn-success btn-lg'
            href: @appUrl()
          ,
            'Go to App'
