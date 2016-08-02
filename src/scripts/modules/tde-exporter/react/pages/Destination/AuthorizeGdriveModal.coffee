React = require 'react'
{ModalFooter, Modal, ModalHeader, ModalTitle, ModalBody} = require('react-bootstrap')
{button, strong, div, h2, span, h4, section, p} = React.DOM
AuthorizeAccount = React.createFactory(require('../../../../google-utils/react/AuthorizeAccount'))
ApplicationStore = require '../../../../../stores/ApplicationStore'
{Map} = require 'immutable'

Button = React.createFactory(require('react-bootstrap').Button)
ButtonToolbar = React.createFactory(require('react-bootstrap').ButtonToolbar)
RouterStore = require('../../../../../stores/RoutesStore')

module.exports = React.createClass
  displayName: 'AuthorizeGdriveModal'

  render: ->
    show = !!@props.localState?.get('show')
    React.createElement Modal,
      show: show
      onHide: =>
        @props.updateLocalState(Map())
      title: 'Authorize Google Drive Account'
    ,
        AuthorizeAccount
          renderToForm: true
          caption: 'Authorize'
          className: 'pull-right'
          componentName: 'wr-google-drive'
          isInstantOnly: true
          refererUrl: @_getReferrer()
          noConfig: true
        ,
          div className: 'modal-body',
            div null, 'You are about to authorize a Google Drive account for offline access.'
          div className: 'modal-footer',
            ButtonToolbar null,
              Button
                className: 'btn btn-link'
                onClick: =>
                  @props.updateLocalState(Map())
              ,
                'Cancel'
              Button
                type: 'submit'
                className: 'btn btn-success'
                'Authorize'

  _getReferrer: ->
    origin = 'https://connection.keboola.com'
    url = RouterStore.getRouter().makeHref('tde-exporter-gdrive-redirect', config: @props.configId)
    projectUrl = ApplicationStore.getProjectBaseUrl()
    result = "#{origin}#{url}"
    return result
