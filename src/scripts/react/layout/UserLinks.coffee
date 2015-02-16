React = require 'react'
ImmutableRendererMixin = require '../../react/mixins/ImmutableRendererMixin'
ApplicationStore = require '../../stores/ApplicationStore'

{div, ul, li, a, span} = React.DOM

module.exports = React.createClass
  displayName: 'UserLinks'
  mixins: [ImmutableRendererMixin]
  render: ->
    div className: 'kbc-user-links',
      ul className: 'nav',
        li null,
          a href: '',
            span className: 'kbc-icon-comment'
            ' Support '
        li null,
          a href: ApplicationStore.getProjectPageUrl('settings'),
            span className: 'kbc-icon-user'
            ' Users & Settings '

