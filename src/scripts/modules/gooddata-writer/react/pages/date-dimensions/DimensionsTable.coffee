React = require 'react'

{table, thead, tbody, tr, th} = React.DOM

pureRenderMixin = require('../../../../../react/mixins/ImmutableRendererMixin')

DateDimensionRow = require './DateDimensionsRow'

module.exports = React.createClass
  displayName: 'DimensionsTable'
  mixins: [pureRenderMixin]
  propTypes:
    dimensions: React.PropTypes.object.isRequired
    configurationId: React.PropTypes.string.isRequired

  render: ->
    table className: 'table table-striped',
      thead null,
        tr null,
          th null, 'Name'
          th null, 'Include time'
          th null
      tbody null,
        @props.dimensions.map (dimension) ->
          React.createElement DateDimensionRow,
            key: dimension.get 'id'
            dimension: dimension
            configurationId: @props.configurationId
        , @
        .toArray()