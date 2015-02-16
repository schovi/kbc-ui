React = require 'react'
CodeEditor  = React.createFactory(require('../../../../../react/common/common').CodeEditor)
Check = React.createFactory(require('../../../../../react/common/common').Check)

{div, table, tbody, tr, td, ul, li, a, span, h2, p, strong} = React.DOM


module.exports = React.createClass
  displayName: 'ExDbQueryDetailStatic'
  propTypes:
    query: React.PropTypes.object.isRequired

  render: ->
    div className: 'container-fluid kbc-main-content',
      div className: 'table kbc-table-border-vertical kbc-detail-table',
        div className: 'tr',
          div className: 'td',
            div className: 'row',
              span className: 'col-md-3', 'Output table '
              strong className: 'col-md-9',
                @props.query.get 'outputTable'
          div className: 'td',
            div className: 'row',
              span className: 'col-md-3', 'Primary key '
              strong className: 'col-md-9',
                @props.query.get 'primaryKey'
            div className: 'row',
              span className: 'col-md-3', 'Incremental '
              strong className: 'col-md-9',
                Check isChecked: @props.query.get 'incremental'
      div
        style:
          'margin-top': '-30px'
      ,
        CodeEditor
          readOnly: true
          value: @props.query.get 'query'