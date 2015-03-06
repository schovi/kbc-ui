
d3 = require 'd3'
dagreD3 = require 'dagre-d3'
_ = require 'underscore'
assign = require 'object-assign'

class Graph

  constructor: (@data, wrapperElement, localScope) ->

    @localScope = localScope

    @zoom =
      scale: 1

    @position =
      x: 0
      y: 0

    @spacing = 2

    @dimensions =
      height: 0
      width: 0

    @direction = 'reverse'

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
      if (@direction == 'reverse')
        data.addEdge null, @data.transitions[i].target, @data.transitions[i].source,
          type: if @data.transitions[i].transitive then 'transitive' else ''
      else
        data.addEdge null, @data.transitions[i].source, @data.transitions[i].target,
          type: if @data.transitions[i].transitive then 'transitive' else ''
    return data

  # add classes to paths
  getEdgeType: (edges, id, type) ->
    result = false
    _.map edges, (dataEdge, key) ->
      if key == id && dataEdge.value.type == type
        result = true
    result

  # add classes to nodes
  getNodeType: (nodes, id, type) ->
    result = false
    nodes.forEach (dataNode) ->
      if dataNode.node == id && dataNode.type == type
        result = true
    result

  createSvg: (svg, data, config) =>
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

    d3.selectAll("g.node").classed({"dataset": (gNode) ->
      graph.getNodeType(graph.data.nodes, gNode, 'dataset')
    , "dimension": (gNode) ->
      graph.getNodeType(graph.data.nodes, gNode, 'dimension')
    })

    d3.selectAll("g.edgePath").classed({"transitive": (gPath) ->
      graph.getEdgeType(gEdges, gPath, 'transitive')
    })

    @dimensions =
      width: layout.graph().width
      height: layout.graph().height

  zoomIn: ->
    prevZoomScale = @zoom.scale
    @zoom.scale = Math.min(1.75, @zoom.scale + 0.25)
    factor = @zoom.scale / prevZoomScale
    if (factor != 1)
      @position.x = (@position.x - @getCanvasWidth() / 2) * factor + @getCanvasWidth() / 2
      @position.y = (@position.y - @getCanvasHeight() / 2) * factor + @getCanvasHeight() / 2
    d3
    .select(@element)
    .select("g")
    .attr "transform", "translate(" + [@position.x, @position.y] + "), scale(" + @zoom.scale + ")"

  zoomOut: ->
    prevZoomScale = @zoom.scale
    @zoom.scale = Math.max(0.5, @zoom.scale - 0.25)
    factor = @zoom.scale / prevZoomScale
    if (factor != 1)
      @position.x = (@position.x - @getCanvasWidth() / 2) * factor + @getCanvasWidth() / 2
      @position.y = (@position.y - @getCanvasHeight() / 2) * factor + @getCanvasHeight() / 2
    d3
    .select(@element)
    .select("g")
    .attr "transform", "translate(" + [@position.x, @position.y] + "), scale(" + @zoom.scale + ")"

  reset: ->
    @position.x = 0
    @position.y = 0
    @zoom.scale = 1
    d3
    .select(@element)
    .select("g")
    .attr "transform", "translate(" + [@position.x, @position.y] + "), scale(" + @zoom.scale + ")"

  getCanvasHeight: ->
    Math.min(500, Math.max(200, @dimensions.height * @zoom.scale))

  getCanvasWidth: ->
    width =  @element.parentNode.offsetWidth
    console.log 'width', width
    width

  adjustCanvasWidth: ->
    d3.select(@element).attr "width", @getCanvasWidth()

  download: ->
    config = {noLinks: true}
    data = @getData(config)
    if data
      # create a new svg
      angular.element("body").append(@svgTemplate.replace('svgGraph', 'svgDownload'))

      dimensions = @createSvg(d3.select("#svgDownload"), data, config)

      svgElement = $document.find('#svgDownload').get(0)
      # detect height and width

      d3.select(svgElement).attr "width", dimensions.width * @zoom.scale + 10
      d3.select(svgElement).attr "height", dimensions.height * @zoom.scale + 10


      # add styles
      d3.select(svgElement).selectAll("g.edgePath")
        .style("fill", "none")
        .style("stroke", "grey")
        .style("stroke-width", "1.5px")

      d3.select(svgElement).selectAll("g.edgePath.transitive")
        .style("stroke-dasharray", "5, 5")


      d3.select(svgElement).selectAll("g.node text")
        .style("color", "#ffffff")
        .style("fill", "#ffffff")
        .style("display", "inline-block")
        .style("padding", "2px 4px")
        .style("font-size", "12px")
        .style("font-weight", "bold")
        .style("line-height", "14px")
        .style("text-shadow", "0 -1px 0 rgba(0, 0, 0, 0.25)")
        .style("white-space", "nowrap")
        .style("vertical-align", "baseline")

      d3.select(svgElement).selectAll(".node.dataset rect")
        .style("fill", "#468847")

      d3.select(svgElement).selectAll(".node.dimension rect")
        .style("fill", "#428bca")

      # apply zoom
      d3.select(svgElement).select("g").attr "transform", "translate(" + [5 , 5] + "), scale(" + @zoom.scale + ")"

      #create canvas
      angular.element("body").append(@canvasTemplate)

      # conver canvast to img
      xml = new XMLSerializer().serializeToString(svgElement)

      canvg('canvasDownload', xml, { ignoreMouse: true, ignoreAnimation: true })
      canvas = $document.find("#canvasDownload").get(0)

      image = canvas.toDataURL("image/png")
      @localScope.openWindow(image)
      @localScope.cleanDom("canvasDownload")
      @localScope.cleanDom("svgDownload")

  render: ->
    data = @getData()

    d3.select(@element).attr "width", @element.parentNode.offsetWidth
    d3.select(@element).attr "height", 500

    if data
      svg = d3.select(@element)
      graph = @

      @createSvg(svg, data)

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
