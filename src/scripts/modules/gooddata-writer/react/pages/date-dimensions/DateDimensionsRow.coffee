React = require 'react'
pureRenderMixin = require('../../../../../react/mixins/ImmutableRendererMixin')

{tr, td, button, span, strong} = React.DOM
{Check, Loader} = require 'kbc-react-components'
Tooltip = require '../../../../../react/common/Tooltip'
Confirm = require '../../../../../react/common/Confirm'

DeleteButton = require '../../../../../react/common/DeleteButton'

actionCreators = require '../../../actionCreators'


module.exports = React.createClass
  displayName: 'DateDimensionsRow'
  mixins: [pureRenderMixin]
  propTypes:
    dimension: React.PropTypes.object.isRequired
    configurationId: React.PropTypes.string.isRequired

  _handleDelete: ->
    actionCreators.deleteDateDimension(@props.configurationId, @props.dimension.get('id'))

  _handleUpload: ->
    actionCreators.uploadDateDimensionToGoodData(@props.configurationId, @props.dimension.get('id'))

  render: ->
    tr null,
      td null,
        @props.dimension.getIn ['data', 'name']
      td null,
        React.createElement Check,
          isChecked: @props.dimension.getIn ['data', 'includeTime']
      td className: 'text-right',
        React.createElement DeleteButton,
          tooltip: 'Delete date dimension'
          isPending: @props.dimension.get('pendingActions').contains 'delete'
          confirm:
            title: 'Delete Date Dimension'
            text: span null,
              'Do you really want to delete date dimension '
              strong null, @props.dimension.getIn ['data', 'name']
              ' ?'
            onConfirm: @_handleDelete
        if @props.dimension.get('pendingActions').contains 'upload'
          React.DOM.span className: 'btn btn-link',
            React.createElement Loader, className: 'fa-fw'
        else
          React.createElement Tooltip,
            tooltip: 'Upload date dimension to GoodData'
          ,
            React.createElement Confirm,
              text: span null,
                'Are you sure you want to upload date dimension '
                strong null, @props.dimension.getIn(['data', 'name'])
                ' to GoodData project?'
              title: 'Upload Date Dimension'
              buttonLabel: 'Upload'
              buttonType: 'success'
              onConfirm: @_handleUpload
            ,
              button className: 'btn btn-link',
                span className: 'fa fa-upload fa-fw'