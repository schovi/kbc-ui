React = require 'react'
ImmutableRendererMixin = require '../../react/mixins/ImmutableRendererMixin'
ApplicationStore = require '../../stores/ApplicationStore'

{div, ul, li, a, span} = React.DOM

module.exports = React.createClass
  displayName: 'UserLinks'
  mixins: [ImmutableRendererMixin]

  _openSupportModal: (e) ->
    window.Zenbox.init
      dropboxID: ApplicationStore.getKbcVars().getIn(['zendesk', 'project', 'dropboxId'])
      url: ApplicationStore.getKbcVars().getIn(['zendesk', 'project', 'url'])
    window.Zenbox.show() # zendesk global
    e.preventDefault()
    e.stopPropagation()

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

