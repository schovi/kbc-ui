React = require 'react'
CodeEditor  = React.createFactory(require('../../../../../react/common/common').CodeEditor)
Check = React.createFactory(require('kbc-react-components').Check)
StaticText = React.createFactory(require('react-bootstrap').FormControls.Static)
SapiTableLinkEx = React.createFactory(require('../../../../components/react/components/StorageApiTableLinkEx'))
{div, table, tbody, tr, td, ul, li, a, span, h2, p, strong, label, input} = React.DOM


module.exports = React.createClass
  displayName: 'ExDbQueryDetailStatic'
  propTypes:
    query: React.PropTypes.object.isRequired

  render: ->
    div className: 'row',
      div className: 'form-horizontal',
        div className: 'form-group',
          label className: 'col-md-2 control-label', 'Name'
          div className: 'col-md-4',
            input
              className: 'form-control'
              type: 'text'
              value: @props.query.get 'name'
              placeholder: 'Untitled Query'
              disabled: true
          label className: 'col-md-2 control-label', 'Primary key'
          div className: 'col-md-4',
          input
            className: 'form-control'
            type: 'text'
            value: @props.query.get 'primaryKey'
            placeholder: 'No primary key'
            disabled: true
        div className: 'form-group',
          label className: 'col-md-2 control-label', 'Output table'
          div className: 'col-md-4',
            SapiTableLinkEx
              tableId: @props.query.get 'outputTable'
            ,
              div
                className: 'form-control-static col-md-12'
                @props.query.get 'outputTable'
          div className: 'col-md-4 col-md-offset-2 checkbox',
            label null,
              input
                type: 'checkbox'
                checked: @props.query.get 'incremental'
                disabled: true
              'Incremental'
        div className: 'form-group',
          label className: 'col-md-12 control-label', 'SQL query'
          div className: 'col-md-12',
            if @props.query.get('query').length
              CodeEditor
                readOnly: 'nocursor'
                lineNumbers: false
                value: @props.query.get 'query'
            else
              div className: 'row kbc-header',
                p className: 'text-muted',
                  'SQL query not set.'
