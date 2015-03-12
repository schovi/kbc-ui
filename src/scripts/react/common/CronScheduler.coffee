React = require 'react'
later = require 'later'
_ = require 'underscore'
Select = require 'react-select'


MODE_OPTIONS = [
  value: later.hour.name
  label: 'Hour'
,
  value: later.day.name
  label: 'Day'
,
  value: later.dayOfWeek.name
  label: 'Week'
,
  value: later.month.name
  label: 'Month'
,
  value: later.year.name
  label: 'Year'
]

MONTHS = ['January', 'February', 'March']

module.exports = React.createClass
  displayName: 'CronScheduler'
  propTypes:
    crontabRecord: React.PropTypes.string.isRequired
    onChange: React.PropTypes.func.isRequired

  render: ->
    console.log 'later', later
    console.log 'parsed', later.parse.cron @props.crontabRecord
    @schedule = later.parse.cron(@props.crontabRecord).schedules[0]

    currentPeriod = @_getCurrentPeriod()

    React.DOM.div null,
      @props.crontabRecord
      'Every '
      @_periodSelect()
      if currentPeriod == later.year.name
        React.DOM.span null,
          ' on the '
          @_daySelect()
          ' of '
          @_monthSelect()
      else if currentPeriod == later.month.propName
        React.DOM.span null,
          ' on the '
          @_daySelect()
      ' at '
      if currentPeriod != later.hour.propName
        React.DOM.span null,
          @_hourSelect()
          ' : '
      @_minuteSelect()


  _periodSelect: ->
    React.createElement Select,
      options: MODE_OPTIONS
      value: @_getCurrentPeriod()
      onChange: @_handlePeriodChange

  _daySelect: ->
    React.createElement Select,
      options: _.range(0, 31).map (value) ->
        value: value
        label: value
      value: @schedule['D']?.join(',')
      multi: true
      onChange: @_handleChange.bind @, 'D'

  _monthSelect: ->
    options = MONTHS.map (value, key) ->
      value: "#{key + 1}"
      label: value
    console.log 'mont opts', options
    React.createElement Select,
      options: options
      value: @schedule['M']?.join(',')
      multi: true
      onChange: @_handleChange.bind @, 'M'

  _hourSelect: ->
    React.createElement Select,
      options: _.range(0, 24).map (value) ->
        value: value
        label: value
      value: @schedule['h']?.join(',')
      multi: true
      onChange: @_handleChange.bind @, 'h'

  _minuteSelect: ->
    React.createElement Select,
      options: _.range(0, 60).map (value) ->
        value: value
        label: value
      value: @schedule['m']?.join(',')
      placeholder: '-- all --'
      multi: true
      onChange: @_handleChange.bind @, 'm'

  _handleChange: (propName, newValue) ->
    console.log 'change', propName, newValue
    schedule = @schedule
    if newValue
      schedule[propName] = newValue.split(',')
    else
      delete schedule[propName]
    @props.onChange @_scheduleToCron schedule

  _handlePeriodChange: (newValue) ->
    console.log 'period change', newValue

  _getCurrentPeriod: ->
    schedules = @schedule
    if schedules['M']
      return later.year.name
    if schedules['D']
      return later.month.name
    if schedules['H']
      return later.day.name
    return later.hour.name

  _scheduleToCron: (schedule) ->
    console.log 'new schedule', schedule
    flatten = (part) ->
      if !part
        return '*'
      else
        return part.join(',')

    parts = []
    parts.push flatten schedule['m']
    parts.push flatten schedule['h']
    parts.push flatten schedule['D']
    parts.push flatten schedule['M']
    parts.push flatten schedule['M']

    parts.join ' '
