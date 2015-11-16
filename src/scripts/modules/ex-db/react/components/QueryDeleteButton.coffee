React = require 'react'
ExDbActionCreators = require '../../exDbActionCreators'

Tooltip = React.createFactory(require('react-bootstrap').Tooltip)
OverlayTrigger = React.createFactory(require('react-bootstrap').OverlayTrigger)
Confirm = React.createFactory(require('../../../../react/common/Confirm').default)
Loader = React.createFactory(require('kbc-react-components').Loader)
{Navigation} = require 'react-router'

{button, span, i} = React.DOM

###
  Enabled/Disabled orchestration button with tooltip
###
module.exports = React.createClass
  displayName: 'QueryDeleteButton'
  mixins: [Navigation]
  propTypes:
    query: React.PropTypes.object.isRequired
    configurationId: React.PropTypes.string.isRequired
    isPending: React.PropTypes.bool.isRequired
    tooltipPlacement: React.PropTypes.string

  getDefaultProps: ->
    tooltipPlacement: 'top'

  render: ->
    if @props.isPending
      span className: 'btn btn-link',
        Loader()
    else
      OverlayTrigger
        overlay: Tooltip null, 'Delete Query'
        key: 'delete'
        placement: @props.tooltipPlacement
      ,
        Confirm
          title: 'Delete Query'
          text: "Do you really want to delete query #{@props.query.get('name')}?"
          buttonLabel: 'Delete'
          onConfirm: @_deleteQuery
        ,
          button className: 'btn btn-link',
            i className: 'kbc-icon-cup'

  _deleteQuery: ->
    @transitionTo 'ex-db',
      config: @props.configurationId

    # if query is deleted immediatelly view is rendered with missing orchestration because of store changed
    id = @props.query.get('id')
    config = @props.configurationId
    setTimeout ->
      ExDbActionCreators.deleteQuery config, id