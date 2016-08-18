React = require 'react'
ImmutableRendererMixin = require '../../react/mixins/ImmutableRendererMixin'
ApplicationStore = require '../../stores/ApplicationStore'
contactSupport = require('../../utils/contactSupport').default

{OverlayTrigger, Popover} =  require 'react-bootstrap'

help = React.createElement Popover, title: 'help',
  React.DOM.strong null, 'test'

{div, ul, li, a, span} = React.DOM

module.exports = React.createClass
  displayName: 'UserLinks'
  mixins: [ImmutableRendererMixin]

  _openSupportModal: (e) ->
    contactSupport(type: 'project')
    e.preventDefault()
    e.stopPropagation()

  render: ->
    div className: 'kbc-user-links',
      ul className: 'nav',
        React.createElement OverlayTrigger,
          trigger: 'click'
          placement: 'right'
          overlay: help
        ,
          li null,
            span className: 'kbc-icon fa fa-question-circle', style: top: '1px'
            ' Help '
        li null,
          a href: ApplicationStore.getProjectPageUrl('settings-users'),
            span className: 'kbc-icon kbc-icon-user'
            ' Users & Settings '

