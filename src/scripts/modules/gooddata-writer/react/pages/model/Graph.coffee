React = require 'react'

GraphCanvas = require './GraphCanvas'

module.exports = React.createClass
  displayName: 'Graph'
  propTypes:
    model: React.PropTypes.object.isRequired

  componentDidMount: ->
    console.log 'mount', @props.model, @refs.graph.getDOMNode()

    graph = new GraphCanvas(@props.model.toJS(),
      @refs.graph.getDOMNode()
    )

  render: ->
    React.DOM.div null,
      React.DOM.div null,
        'TODO controls',
      React.DOM.div null,
        React.DOM.div
          className: 'svg'
        React.DOM.div
          id: 'canGraph'
          ref: 'graph'
