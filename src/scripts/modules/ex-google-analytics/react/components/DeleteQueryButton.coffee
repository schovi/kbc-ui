React = require 'react'
ExGanalctionCreators = require '../../exGanalActionCreators'

Tooltip = React.createFactory(require('react-bootstrap').Tooltip)
OverlayTrigger = React.createFactory(require('react-bootstrap').OverlayTrigger)
Confirm = React.createFactory(require('../../../../react/common/Confirm').default)

{button, span, i} = React.DOM

###
  Enabled/Disabled orchestration button with tooltip
###
module.exports = React.createClass
  displayName: 'DeleteQueryButton'
  propTypes:
    queryName: React.PropTypes.string.isRequired
    configurationId: React.PropTypes.string.isRequired

  render: ->
    OverlayTrigger
      overlay: Tooltip null, 'Delete Query'
      key: 'delete'
      placement: 'top'
    ,
      Confirm
        title: 'Delete Query'
        text: "Do you really want to delete query?"
        buttonLabel: 'Delete'
        onConfirm: @_deleteQuery
      ,
        button className: 'btn btn-link',
          i className: 'kbc-icon-cup'

  _deleteQuery: ->
    ExGanalctionCreators.deleteQuery @props.configurationId, @props.queryName
