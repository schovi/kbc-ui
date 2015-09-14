React = require 'react'
ImmutableRendererMixin = require '../../react/mixins/ImmutableRendererMixin'
ApplicationStore = require '../../stores/ApplicationStore'
contactSupport = require '../../utils/contactSupport'

{div, ul, li, a, span} = React.DOM

module.exports = React.createClass
  displayName: 'UserLinks'
  mixins: [ImmutableRendererMixin]

  _openSupportModal: (e) ->
    e.preventDefault()
    e.stopPropagation()
    contactSupport(type: 'project')
    false

  render: ->
    div className: 'kbc-user-links',
      ul className: 'nav',
        li null,
          a
            href: ''
            onClick: @_openSupportModal
          ,
            span className: 'kbc-icon kbc-icon-comment'
            ' Support '
        li null,
          a href: ApplicationStore.getProjectPageUrl('settings'),
            span className: 'kbc-icon kbc-icon-user'
            ' Users & Settings '

