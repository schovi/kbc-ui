React = require 'react'

{ActivateDeactivateButton, Confirm, Tooltip} = require '../../../../../react/common/common'
{span, i, button, strong, div} = React.DOM
Link = React.createFactory(require('react-router').Link)

ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
RunButtonModal = React.createFactory(require('../../../../components/react/components/RunComponentButton'))


module.exports = React.createClass
  displayName: 'WrGdriveTableRow'
  mixins: [ImmutableRenderMixin]

  propTypes:
    isTableExported: React.PropTypes.bool.isRequired
    isPending: React.PropTypes.bool.isRequired
    onExportChangeFn: React.PropTypes.func.isRequired
    table: React.PropTypes.object.isRequired
    file: React.PropTypes.object.isRequired
    configId: React.PropTypes.string.isRequired

  render: ->
    div className: 'tr',
      span className: 'td',
        @props.table.get 'name'
      span className: 'td',
        i className: 'fa fa-fw fa-long-arrow-right'
      span className: 'td',
        @props.file?.get 'title'
      span className: 'td',
        @props.file?.get 'operation'
      span className: 'td',
        @props.file?.get 'type'
      span className: 'td',
        @props.file?.get('targetFolder')
      span className: 'td',
        'preview todo'
      span className: 'td',
        'actions'
