React = require 'react'
{span, div, a, p, h2} = React.DOM
ApplicationStore = require '../../../../../stores/ApplicationStore'
ComponentIcon = React.createFactory(require '../../../../../react/common/ComponentIcon')
ComponentsStore = require '../../../../components/stores/ComponentsStore'
Link = React.createFactory(require('react-router').Link)

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
          @_renderIcon()
          h2 null, @props.app.get 'name'
          p null, @props.app.get 'description'
          @_renderLink()

  _renderLink: ->
    if @props.app.has 'link'
      Link
        to: @props.app.get 'link'
        className: 'btn btn-success btn-lg'
      ,
        'Go To App'

    else
      a
        className: 'btn btn-success btn-lg'
        href: @appUrl()
      ,
        'Go to App'


  _renderIcon: ->
    component = ComponentsStore.getComponent(@props.app.get 'id')
    if component
      ComponentIcon
        component: component
        size: '64'
