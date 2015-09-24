React = require 'react'
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
Link = React.createFactory(require('react-router').Link)

{ActivateDeactivateButton, Confirm, Tooltip} = require '../../../../../react/common/common'
{Loader} = require 'kbc-react-components'
SapiTableLinkEx = React.createFactory(require('../../../../components/react/components/StorageApiTableLinkEx'))

actionCreators = require '../../../actionCreators'

{span, div, a, button, i, strong} = React.DOM

module.exports = React.createClass
  displayName: 'TableRow'
  mixins: [ImmutableRenderMixin]
  propTypes:
    table: React.PropTypes.object.isRequired
    configId: React.PropTypes.string.isRequired

  render: ->
    Link
      className: 'tr'
      to: 'gooddata-writer-table'
      params:
        config: @props.configId
        table: @props.table.get 'id'
    ,
      span className: 'td',
        SapiTableLinkEx tableId: @props.table.get 'id',
          @props.table.getIn ['data', 'sapiName']
      span className: 'td',
        @props.table.getIn ['data', 'title']
      span className: 'td text-right',
        React.createElement ActivateDeactivateButton,
          activateTooltip: 'Enable Export'
          deactivateTooltip: 'Disable Export'
          isActive: @props.table.getIn ['data', 'export']
          isPending: @props.table.get('savingFields').contains 'export'
          onChange: @_handleExportChange
        if @props.table.get('pendingActions').contains 'uploadTable'
          React.DOM.span className: 'btn btn-link',
            React.createElement Loader, className: 'fa-fw'
        else
          React.createElement Tooltip,
            tooltip: 'Upload table to GoodData'
          ,
            React.createElement Confirm,
              text: @_uploadText()
              title: 'Upload Table'
              buttonLabel: 'Upload'
              buttonType: 'success'
              onConfirm: @_handleUpload
            ,
              button className: 'btn btn-link',
                span className: 'fa fa-upload fa-fw'

  _uploadText: ->
    span null,
      'Are you sure you want to upload table '
      strong null, @props.table.getIn(['data', 'name'])
      ' to GoodData project?'

  _handleUpload: ->
    actionCreators.uploadToGoodData(@props.configId, @props.table.get('id'))

  _handleExportChange: (newExportStatus) ->
    actionCreators.saveTableField(@props.configId, @props.table.get('id'), 'export', newExportStatus)
