React = require 'react'

GraphCanvas = require '../../../../../react/common/GraphCanvas'
Button = React.createFactory(require('react-bootstrap').Button)
PureRenderMixin = require('react/addons').addons.PureRenderMixin
Navigation = require('react-router').Navigation

graphUtils = require '../../../../../utils/graphUtils'

module.exports = React.createClass

  displayName: 'Graph'

  mixins: [Navigation]

  propTypes:
    model: React.PropTypes.object.isRequired
    centerNodeId: React.PropTypes.string
    showDisabled: React.PropTypes.bool.isRequired
    disabledTransformation: React.PropTypes.bool.isRequired
    showDisabledHandler: React.PropTypes.func.isRequired

  _modelData: ->
    model = @props.model.toJS()
    model.nodes = graphUtils.addLinksToNodes(model.nodes)
    model

  _renderGraph: ->
    @graph.data = @_modelData()
    @graph.direction  = 'regular'
    @graph.spacing = 1
    @graph.styles =
      "g.edgePath":
        "fill": "none"
        "stroke": "grey"
        "stroke-width": "1.5px"
      "g.edgePath.alias":
        "stroke-dasharray": "5, 5"
      "g.node text":
        "color": "#ffffff"
        "fill": "#ffffff"
        "display": "inline-block"
        "padding": "2px 4px"
        "font-size": "12px"
        "font-weight": "bold"
        "line-height": "14px"
        "text-shadow": "0 -1px 0 rgba(0, 0, 0, 0.25)"
        "white-space": "nowrap"
        "vertical-align": "baseline"
      ".node.transformation rect":
        "fill": "#363636"
      ".node.remote-transformation rect":
        "fill": "#999999"
      ".node.writer rect":
        "fill": "#faa732"
      ".node.input rect":
        "fill": "#468847"
      ".node.output rect":
        "fill": "#3a87ad"
    @graph.render(@props.centerNodeId)

  componentWillUnmount: ->
    window.removeEventListener('resize', @handleResize)

  componentDidMount: ->
    window.addEventListener('resize', @handleResize)
    @graph = new GraphCanvas {}, @refs.graph.getDOMNode()
    @_renderGraph()

  componentDidUpdate: ->
    @_renderGraph()

  _handleZoomIn: ->
    @graph.zoomIn()

  _handleZoomOut: ->
    @graph.zoomOut()

  _handleReset: ->
    @graph.reset()

  _handleDownload: ->
    @graph.download()

  handleResize: (e) ->
    @graph.adjustCanvasWidth()

  _handleChangeShowDisabled: (e) ->
    showDisabled = e.target.checked
    @props.showDisabledHandler(showDisabled)

  render: ->
    React.DOM.div {},
      React.DOM.div {},
        React.DOM.div className: 'graph-options',
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
          React.DOM.span
            className: 'pull-right checkbox'
            style:
              marginTop: '5px'
            if @props.disabledTransformation
              React.DOM.small {},
                'Showing all disabled transformations'
            else
              React.DOM.label className: 'control-label',
                React.DOM.input
                  type: 'checkbox'
                  onChange: @_handleChangeShowDisabled
                  checked: @props.showDisabled
                  ref: 'showDisabled'
                ' Show disabled transformations'

      React.DOM.div {},
        React.DOM.div
          className: 'svg'
        React.DOM.div
          id: 'canGraph'
          ref: 'graph'
