React = require 'react'

{table, tr, th, tbody, thead} = React.DOM

Row = React.createFactory(require './DatasetColumnEditorRow')
pureRendererMixin = require '../../../../../react/mixins/ImmutableRendererMixin'

module.exports = React.createClass
  displayName: 'DatasetColumnsEditor'
  mixins: [pureRendererMixin]
  propTypes:
    columns: React.PropTypes.object.isRequired
    isEditing: React.PropTypes.bool.isRequired

  render: ->
    table className: 'table table-striped',
      thead null,
        tr null,
          th null, 'Column'
          th null, 'GoodData name'
          th null, 'Type'
          th null, 'Reference'
          th null, 'Sort Label'
          th null, 'Data Type'
          th null
      tbody null,
        @props.columns.map (column) ->
          Row
            column: column
            isEditing: @props.isEditing
            key: column.get 'name'
        , @
        .toArray()



