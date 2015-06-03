React = require 'react'
CodeEditor  = React.createFactory(require('../../../../../react/common/common').CodeEditor)
Check = React.createFactory(require('kbc-react-components').Check)

{div, table, tbody, tr, td, ul, li, a, span, h2, p, strong, label, input} = React.DOM


module.exports = React.createClass
  displayName: 'ExDbQueryDetailStatic'
  propTypes:
    query: React.PropTypes.object.isRequired

  render: ->
    div className: 'container-fluid kbc-main-content',
      div className: 'table kbc-detail-table form-horizontal',
        div className: 'tr',
          div className: 'td',
            div className: 'form-group',
              label className: 'col-md-3 control-label', 'Name'
              div className: 'col-md-9',
                input
                  className: 'form-control'
                  type: 'text'
                  value: @props.query.get 'name'
                  placeholder: 'Untitled Query'
                  disabled: true
            div className: 'form-group',
              label className: 'col-md-3 control-label', 'Output table'
              div className: 'col-md-9',
                input
                  className: 'form-control'
                  type: 'text'
                  placeholder: 'Output table ...'
                  value: @props.query.get 'outputTable'
                  disabled: true
          div className: 'td',
            div className: 'form-group',
              label className: 'col-md-3 control-label', 'Primary key'
                div className: 'col-md-9',
                input
                  className: 'form-control'
                  type: 'text'
                  value: @props.query.get 'primaryKey'
                  placeholder: 'No primary key'
                  disabled: true
            div className: 'form-group',
              div className: 'col-md-9 col-md-offset-3 checkbox',
                label null,
                  input
                    type: 'checkbox'
                    checked: @props.query.get 'incremental'
                    disabled: true
                  'Incremental'
      div
        style:
          'margin-top': '-30px'
      ,
        CodeEditor
          readOnly: true
          value: @props.query.get 'query'
