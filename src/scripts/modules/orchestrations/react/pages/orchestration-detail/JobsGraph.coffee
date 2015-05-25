React = require 'react'
moment = require 'moment'
numeral = require 'numeral'
date = require '../../../../../utils/date'
{Map} = require 'immutable'

dimple = require 'dimple/dist/dimple.v2.1.3.js' # TODO move this require to utils and than require utils/dimple

JobsGraph = React.createClass
  displayName: 'JobsGraph'
  propTypes:
    jobs: React.PropTypes.object.isRequired

  componentDidMount: ->
    width = @getDOMNode().offsetWidth
    svg = dimple.newSvg(@getDOMNode(), width, 0.3 * width)

    data = @_prepareData()

    chart = new dimple.chart(svg, data.get('jobs').toJS())
    chart.addTimeAxis("x", "date", null, "%b %d")
    yAxis = chart.addMeasureAxis("y", "duration")
    yAxis.title = "Duration (#{data.get('unit')})"
    s = chart.addSeries("status", dimple.plot.bar)
    s.getTooltipText = (e) ->
      console.log 'tooltip', e
      [
        "Created: #{date.format(e.xField[0])}"
        "Duration:  #{numeral(e.yValueList[0]).format('0.0')} #{data.get('unit')}",
      ]
    chart.assignColor("error", "red")
    chart.assignColor("success", "#96d130")
    chart.assignColor("warn", "red")
    chart.assignColor("terminated", "black")
    chart.draw()
    @chart = chart

    window.addEventListener("resize", @_refreshGraph)

  componentDidUpdate: ->
    @_refreshGraph()

  componentWillUnmount: ->
    window.removeEventListener("resize", @_refreshGraph)

  _refreshGraph: ->
    width = @getDOMNode().offsetWidth
    data = @_prepareData()
    @chart.axes[1].title = "Duration (#{data.get('unit')})"
    @chart.data = data.get('jobs').toJS()
    @chart.svg.style('width', width)
    @chart.draw(200)

  _prepareData: ->
    jobs = @props.jobs.filter (job) ->
      job.get('startTime') && job.get('endTime')
    .map (job) ->
      Map
        status: job.get('status')
        duration: (new Date(job.get('endTime')).getTime() - new Date(job.get('startTime')).getTime()) / 1000
        date: parseInt(moment(job.get('createdTime')).format('x'))

    maxDuration = jobs.maxBy((job) -> job.get('duration')).get 'duration'
    if maxDuration < 60
      scale = 1
      unit = 'Seconds'
    else if maxDuration < 3600
      scale = 60
      unit = 'Minutes'
    else
      scale = 3600
      unit = 'Hours'

    Map
      scale: scale
      unit: unit
      jobs: jobs.map (job) -> job.set('duration', job.get('duration') / scale)


  render: ->
    React.DOM.div null

module.exports = JobsGraph
