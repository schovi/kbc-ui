React = require 'react'
moment = require 'moment'

dimple = require 'dimple/dist/dimple.v2.1.1.js' # TODO move this require to utils and than require utils/dimple

JobsGraph = React.createClass
  displayName: 'JobsGraph'
  propTypes:
    jobs: React.PropTypes.object.isRequired

  componentDidMount: ->
    width = @getDOMNode().offsetWidth
    svg = dimple.newSvg(@getDOMNode(), width, 0.3 * width)

    jobs = @_prepareData()
    chart = new dimple.chart(svg, jobs)
    chart.addTimeAxis("x", "date", null, "%b %d")
    chart.addMeasureAxis("y", "duration")
    s = chart.addSeries("status", dimple.plot.bar)
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
    @chart.data = @_prepareData()
    @chart.svg.style('width', width)
    @chart.draw(200)

  _prepareData: ->
    @props.jobs.filter( (job) ->
      job.get('startTime') && job.get('endTime')
    ).map((job) ->
      status: job.get('status')
      duration: (new Date(job.get('endTime')).getTime() - new Date(job.get('startTime')).getTime()) / 1000
      hour: (new Date(job.get('createdTime'))).getHours()
      _date: moment(job.get('createdTime')).format('YYYY-MM-DD')
      date: job.get('createdTime')
    ).toJS()



  render: ->
    React.DOM.div null

module.exports = JobsGraph
