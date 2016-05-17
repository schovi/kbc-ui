React = require 'react'
CodeEditor  = React.createFactory(require('../../../../../react/common/common').CodeEditor)
Check = React.createFactory(require('kbc-react-components').Check)
StaticText = React.createFactory(require('react-bootstrap').FormControls.Static)
SapiTableLinkEx = React.createFactory(require('../../../../components/react/components/StorageApiTableLinkEx').default)
{div, table, tbody, tr, td, ul, li, a, span, h2, p, strong, label, input, textarea} = React.DOM

module.exports = React.createClass
  displayName: 'ExDbQueryDetailStatic'
  propTypes:
    query: React.PropTypes.object.isRequired
    mode: React.PropTypes.string.isRequired
    componentId: React.PropTypes.string.isRequired

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
              disabled: true

        div className: 'form-group',
          label className: 'col-md-2 control-label', 'Collection'
          div className: 'col-md-4',
            input
              className: 'form-control'
              type: 'text'
              value: @props.query.get 'collection'
              disabled: true

        div className: 'form-group',
          label className: 'col-md-2 control-label', 'Query'
          div className: 'col-md-10',
            CodeEditor
              readOnly: true
              placeholder: 'Not set'
              value:
                if @props.query.get('query') and @props.query.get('query').length
                  @props.query.get 'query'
                else
                  ''
              mode: 'application/json'
              style: {
                width: '100%'
              }

        div className: 'form-group',
          label className: 'col-md-2 control-label', 'Sort'
          div className: 'col-md-10',
            CodeEditor
              readOnly: true
              placeholder: 'Not set'
              value:
                if @props.query.get('sort') and @props.query.get('sort').length
                  @props.query.get 'sort'
                else
                  ''
              mode: 'application/json'
              style: {
                width: '100%'
              }

        div className: 'form-group',
          label className: 'col-md-2 control-label', 'Limit'
          div className: 'col-md-4',
            input
              className: 'form-control'
              placeholder: 'Not set'
              type: 'text'
              disabled: true
              value:
                if @props.query.get('limit')
                  @props.query.get 'limit'
                else
                  ''

        div className: 'form-group',
          label className: 'col-md-2 control-label', 'Incremental'
          div className: 'col-md-4',
            div
              style:
                marginTop: '1em'
                paddingLeft: '1em',
              input
                readOnly: true
                type: 'checkbox'
                checked: @props.query.get 'incremental'

        div className: 'form-group',
          label className: 'col-md-2 control-label', 'Mapping'
          div className: 'col-md-10',
            CodeEditor
              readOnly: true
              value:
                if @props.query.get('mapping')
                  JSON.stringify(@props.query.get('mapping'), null, 2)
                else
                  ''
              mode: 'application/json'
