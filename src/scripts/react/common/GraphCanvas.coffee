
d3 = require 'd3'
dagreD3 = require 'dagre-d3'
_ = require 'underscore'
canvg = require 'canvg'
assign = require 'object-assign'

class Graph

  constructor: (@data, wrapperElement) ->

    @zoom =
      scale: 1

    @position =
      x: 0
      y: 0

    @spacing = 2

    @styles = {}

    @dimensions =
      height: 0
      width: 0

    @position =
      x: 0
      y: 0

    @defaultPosition =
      x: 0
      y: 0

    @svgTemplate = """
       <svg width="0" height="0" id="svgGraph" class="kb-graph">
         <defs>
           <marker id="arrowhead"
             viewBox="0 0 10 10"
             refX="8"
             refY="5"
             markerUnits="strokeWidth"
             markerWidth="8"
             markerHeight="5"
             orient="auto"
             style="fill: #333">
             <path d="M 0 0 L 10 5 L 0 10 z"></path>
           </marker>
         </defs>
       </svg>
     """

    @canvasTemplate = """
      <canvas id="canvasDownload" width="0" height="0"></canvas>
    """

    wrapperElement.innerHTML = @svgTemplate
    @element = wrapperElement.childNodes[0]

  getData: (config) =>
    config = assign({noLinks: false}, config)
    data = new dagreD3.Digraph()
    for i of @data.nodes
      if (config.noLinks)
        data.addNode @data.nodes[i].node,
          label: @data.nodes[i].label
      else
        data.addNode @data.nodes[i].node,
          label: '<a href="' + @data.nodes[i].link + '">' + @data.nodes[i].label + '</a>'

    for i of @data.transitions
      data.addEdge null, @data.transitions[i].source, @data.transitions[i].target,
        type: @data.transitions[i].type
    return data

  createSvg: (svg, data, config, centerNodeId) =>
    svg.selectAll("*").remove()
    config = assign({noLinks: false}, config)
    renderer = new dagreD3.Renderer()
    graph = @
    gEdges = {}

    oldDrawEdgePaths = renderer.drawEdgePaths()
    renderer.drawEdgePaths((g, u) ->
      edgePaths = oldDrawEdgePaths(g, u)
      gEdges = g._edges
      edgePaths
    )

    if (config.noLinks)
      oldDrawNodes = renderer.drawNodes()
      renderer.drawNodes((g, u) ->
        nodes = oldDrawNodes(g, u)
        # adjust boxes
        nodes[0].forEach( (node) ->
          rect = d3.select(node).select("rect")
          rect
            .attr("width", rect.attr("width") - 12)
            .attr("height", rect.attr("height") - 18)
            .attr("x", -(rect.attr("width") / 2) + 1)
            .attr("y", -(rect.attr("height") / 2))
          textWrapper = d3.select(node).select("g")
          textWrapper
          .attr("transform", "translate(-" + (rect.attr("width") / 2 - 4) + ", -" + (rect.attr("height") / 2 - 2) + ")")
          text = d3.select(node).select("text")
          text.attr('text-anchor', null)
        )
        nodes
      )

    layoutConfig = dagreD3.layout().rankDir("LR").nodeSep(10 * @spacing).edgeSep(10 * @spacing).rankSep(20 * @spacing)
    layout = renderer.zoom(false).layout(layoutConfig).run data, svg.append("g")

    # assign edge classes according to node types
    transitionClassMap = []
    _.each(_.uniq(_.pluck(graph.data.transitions, 'type')), (transitionType) ->
      transitionClassMap[transitionType] = (id) ->
        gEdges[id].value.type == transitionType
    )
    d3.selectAll("g.edgePath").classed(transitionClassMap)

    # assign node classes according to node types
    nodeClassMap = []
    _.each(_.uniq(_.pluck(graph.data.nodes, 'type')), (nodeType) ->
      nodeClassMap[nodeType] = (id) ->
        result = false
        graph.data.nodes.forEach (dataNode) ->
          if dataNode.node == id && dataNode.type == nodeType
            result = true
        result
    )
    d3.selectAll("g.node").classed(nodeClassMap)

    # apply styeles
    _.each(@styles, (styles, selector) ->
      _.each(styles, (value, property) ->
        d3.selectAll(selector).style(property, value)
      )
    )

    @dimensions =
      width: layout.graph().width
      height: layout.graph().height

    if centerNodeId && layout._nodes[centerNodeId]
      @defaultPosition.x = -layout._nodes[centerNodeId].value.x + (@getCanvasWidth() / 2)
      @defaultPosition.y = -layout._nodes[centerNodeId].value.y + (@getCanvasHeight() / 2)


  zoomIn: ->
    prevZoomScale = @zoom.scale
    @zoom.scale = Math.min(1.75, @zoom.scale + 0.25)
    factor = @zoom.scale / prevZoomScale
    if (factor != 1)
      @position.x = (@position.x - @getCanvasWidth() / 2) * factor + @getCanvasWidth() / 2
      @position.y = (@position.y - @getCanvasHeight() / 2) * factor + @getCanvasHeight() / 2
    @setTransform()

  zoomOut: ->
    prevZoomScale = @zoom.scale
    @zoom.scale = Math.max(0.5, @zoom.scale - 0.25)
    factor = @zoom.scale / prevZoomScale
    if (factor != 1)
      @position.x = (@position.x - @getCanvasWidth() / 2) * factor + @getCanvasWidth() / 2
      @position.y = (@position.y - @getCanvasHeight() / 2) * factor + @getCanvasHeight() / 2
    @setTransform()

  reset: ->
    @position.x = @defaultPosition.x
    @position.y = @defaultPosition.y
    @zoom.scale = 1
    @setTransform()

  getCanvasHeight: ->
    Math.min(500, Math.max(200, @dimensions.height * @zoom.scale))

  getCanvasWidth: ->
    @element.parentNode.offsetWidth

  setTransform: ->
    translateExpression = "translate(" + [@position.x, @position.y] + "), scale(" + @zoom.scale + ")"
    d3.select(@element).select("g").attr "transform", translateExpression
    # adjust canvas height
    d3.select(@element).attr "height", @getCanvasHeight()

  adjustCanvasWidth: ->
    d3.select(@element).attr "width", @getCanvasWidth()

  download: ->
    config = {noLinks: true}
    data = @getData(config)
    if data
      # create a new svg
      svgElement = document.createElement 'div'
      svgElement.innerHTML = @svgTemplate.replace('svgGraph', 'svgDownload')
      document.body.appendChild svgElement
      dimensions = @createSvg(d3.select("#svgDownload"), data, config)

      svgElement = document.getElementById('svgDownload')
      # detect height and width

      d3.select(svgElement).attr "width", @dimensions.width * @zoom.scale + 10
      d3.select(svgElement).attr "height", @dimensions.height * @zoom.scale + 10

      # apply zoom
      d3.select(svgElement).select("g").attr "transform", "translate(" + [5 , 5] + "), scale(" + @zoom.scale + ")"

      #create canvas
      canvasElement = document.createElement 'div'
      canvasElement.innerHTML = @canvasTemplate
      document.body.appendChild canvasElement

      # conver canvast to img
      xml = new XMLSerializer().serializeToString(svgElement)

      canvg('canvasDownload', xml, { ignoreMouse: true, ignoreAnimation: true })
      canvas = document.getElementById("canvasDownload")

      image = canvas.toDataURL("image/png")
      window.open image

      svgElement.parentNode.removeChild(svgElement)
      canvasElement.parentNode.removeChild(canvasElement)

  render: (centerNodeId) ->
    data = @getData()

    @adjustCanvasWidth()

    if data
      svg = d3.select(@element)
      graph = @

      @createSvg(svg, data, {}, centerNodeId)
      @reset()

      # init position + dragging
      svg.call d3.behavior.drag().origin(->
        t = svg.select("g")
        x: t.attr("x") + d3.transform(t.attr("transform")).translate[0]
        y: t.attr("y") + d3.transform(t.attr("transform")).translate[1]
      ).on("drag", ->
        graph.position.x = d3.event.x
        graph.position.y = d3.event.y
        svg.select("g").attr "transform", ->
          "translate(" + [d3.event.x, d3.event.y] + "), scale(" + graph.zoom.scale + ")"
      )

    return false

module.exports = Graph
