React = require 'react'
ImmutableRendererMixin = require '../../react/mixins/ImmutableRendererMixin'
ApplicationStore = require '../../stores/ApplicationStore'
contactSupport = require('../../utils/contactSupport').default

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
        li null,
          a
            href: ''
            onClick: @_openSupportModal
          ,
            span className: 'fa fa-comment'
            ' Support '

        li null,
          a
            href: 'https://help.keboola.com'
            target: '_blank',
            span className: 'fa fa-question-circle'
            ' Help '

        li null,
          a href: ApplicationStore.getProjectPageUrl('settings-users'),
            span className: 'fa fa-user'
            ' Users & Settings '
