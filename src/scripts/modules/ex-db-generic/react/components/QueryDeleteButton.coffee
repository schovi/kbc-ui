React = require 'react'

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
    componentId: React.PropTypes.string
    actionsProvisioning: React.PropTypes.object.isRequired

  getDefaultProps: ->
    tooltipPlacement: 'top'

  render: ->
    deleteLabel = (if @props.componentId == 'keboola.ex-mongodb' then 'Delete Export' else 'Delete Query')
    if @props.isPending
      span className: 'btn btn-link',
        Loader()
    else
      OverlayTrigger
        overlay: Tooltip null, deleteLabel
        key: 'delete'
        placement: @props.tooltipPlacement
      ,
        Confirm
          title: deleteLabel
          text: "Do you really want to delete " +
            (if @props.componentId == 'keboola.ex-mongodb' then 'export' else 'query') +
            " #{@props.query.get('name')}?"
          buttonLabel: 'Delete'
          onConfirm: @_deleteQuery
        ,
          button className: 'btn btn-link',
            i className: 'kbc-icon-cup'

  _deleteQuery: ->
    @transitionTo "ex-db-generic-#{@props.componentId}",
      config: @props.configurationId

    # if query is deleted immediatelly view is rendered with missing orchestration because of store changed
    id = @props.query.get('id')
    config = @props.configurationId
    ExDbActionCreators = this.props.actionsProvisioning.createActions(@props.componentId)
    setTimeout ->
      ExDbActionCreators.deleteQuery config, id
