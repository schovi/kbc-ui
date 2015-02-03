React = require 'react'
ExGdriveActionCreators = require '../../exGdriveActionCreators.coffee'

Tooltip = React.createFactory(require('react-bootstrap').Tooltip)
OverlayTrigger = React.createFactory(require('react-bootstrap').OverlayTrigger)
Confirm = React.createFactory(require '../../../../react/common/Confirm.coffee')

{button, span, i} = React.DOM

###
  Enabled/Disabled orchestration button with tooltip
###
module.exports = React.createClass
  displayName: 'DeleteSheetButton'
  propTypes:
    sheet: React.PropTypes.object.isRequired
    configurationId: React.PropTypes.string.isRequired

  render: ->
    OverlayTrigger
      overlay: Tooltip null, 'Delete Sheet'
      key: 'delete'
      placement: 'top'
    ,
      Confirm
        title: 'Delete Sheet'
        text: "Do you really want to delete sheet?"
        buttonLabel: 'Delete'
        onConfirm: @_deleteQuery
      ,
        button className: 'btn btn-link',
          i className: 'kbc-icon-cup'

  _deleteQuery: ->
    ExGdriveActionCreators.deleteSheet @props.configurationId, @props.sheet.get('fileId'), @props.sheet.get('sheetId')
