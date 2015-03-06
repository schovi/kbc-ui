React = require 'react'

GraphCanvas = require './GraphCanvas'
{Button} = require 'react-bootstrap'

module.exports = React.createClass
  displayName: 'Graph'
  propTypes:
    model: React.PropTypes.object.isRequired

  componentDidMount: ->
    console.log 'mount', @props.model, @refs.graph.getDOMNode()

    graph = new GraphCanvas @props.model.toJS(),
      @refs.graph.getDOMNode()

    graph.direction  = 'regular'
    graph.spacing = 1
    graph.render()
    @graph = graph

  _handleZoomIn: ->
    @graph.zoomIn()

  _handleZoomOut: ->
    @graph.zoomOut()

  _handleReset: ->
    @graph.reset()

  _handleDownload: ->
    @graph.download()

  render: ->
    React.DOM.div null,
      React.DOM.div null,
        React.DOM.div className: 'pull-left',
          Button
            bsStyle: 'link'
            onClick: @_handleZoomIn
          ,
            React.DOM.span className: 'fa fa-search-plus'
            ' Zoom in'
          Button
            bsStyle: 'link'
            onClick: @_handleZoomOut
          ,
            React.DOM.span className: 'fa fa-search-minus'
            ' Zoom out'
          Button
            bsStyle: 'link'
            onClick: @_handleReset
          ,
            React.DOM.span className: 'fa fa-times'
            ' Reset'
          Button
            bsStyle: 'link'
            onClick: @_handleDownload
          ,
            React.DOM.span className: 'fa fa-arrow-circle-o-down'
            ' Download'

      React.DOM.div null,
        React.DOM.div
          className: 'svg'
        React.DOM.div
          id: 'canGraph'
          ref: 'graph'
