React = require 'react'
later = require 'later'
_ = require 'underscore'
Select = require 'react-select'
moment = require 'moment-timezone'
date = require '../../utils/date'


PERIOD_OPTIONS = [
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

MONTHS = [
  'January'
  'February'
  'March'
  'April'
  'May'
  'June'
  'July'
  'August'
  'September'
  'October'
  'November'
  'December'
]

DAYS = [
  'Sunday'
  'Monday'
  'Tuesday'
  'Wednesday'
  'Thursday'
  'Friday'
  'Saturday'
]

lpad = (value, padding) ->
  zeroes = "0"
  zeroes += "0" for i in [1..padding]

  (zeroes + value).slice(padding * -1)

{div, label, p} = React.DOM

Scheduler = React.createClass
  displayName: 'CronScheduler'
  propTypes:
    M: React.PropTypes.array.isRequired
    D: React.PropTypes.array.isRequired
    d: React.PropTypes.array.isRequired
    h: React.PropTypes.array.isRequired
    m: React.PropTypes.array.isRequired
    period: React.PropTypes.string.isRequired
    next: React.PropTypes.array.isRequired
    onChange: React.PropTypes.func.isRequired
    onPeriodChange: React.PropTypes.func.isRequired
  render: ->
    currentPeriod = @props.period
    div
      className: 'form'
    ,
      div className: 'form-group',
        label null,
          'Every '
        div null,
          @_periodSelect()
      switch currentPeriod
        when later.year.name
          div key: 'year',
            div className: 'form-group',
              label null,
                ' on the '
              @_daySelect()
            div className: 'form-group',
              label null,
                ' of '
              @_monthSelect()
            @_hoursAndMinutes()
        when later.month.name
          React.DOM.div key: 'month',
            div className: 'form-group',
              label null,
                ' on the '
              @_daySelect()
            @_hoursAndMinutes()
        when later.dayOfWeek.name
          React.DOM.div key: 'dayOfWeek',
            div className: 'form-group',
              label null,
              ' on '
              @_dayOfWeekSelect()
            @_hoursAndMinutes()
        when later.day.name
          React.DOM.div  key: 'day',
            @_hoursAndMinutes()
        else
          div className: 'form-group',
            label null,
              'at'
            @_minuteSelect()
      div null,
        React.DOM.h3 null,
          'Next Schedules '
          React.DOM.small null,
            '(In your local time)'
        React.DOM.ul null,
          @props.next.map (time) ->
            React.DOM.li key: time,
              date.format time

  _hoursAndMinutes: ->
    div null,
      div className: 'form-group',
        label null,
          ' at '
        React.DOM.span null,
        @_hourSelect()
        p className: 'help-block',
          'Hours '
          React.DOM.strong null, 'UTC'
          React.DOM.span className: 'text-muted',
            ' (Current time is '
            moment().tz('UTC').format('HH:mm')
            ' UTC)'
      div className: 'form-group',
        @_minuteSelect()
        p className: 'help-block',
          'Minutes'

  _periodSelect: ->
    React.createElement Select,
      options: PERIOD_OPTIONS
      value: @props.period
      onChange: @props.onPeriodChange

  _daySelect: ->
    React.createElement Select,
      options: _.range(0, 31).map (value) ->
        value: "#{value + 1}"
        label: "#{value + 1}."
      value: @_valueForMultiSelect @props.D
      multi: true
      placeholder: '-- Every Day --'
      onChange: @_handleChange.bind @, 'D'

  _monthSelect: ->
    options = MONTHS.map (value, key) ->
      value: "#{key + 1}"
      label: value
    React.createElement Select,
      options: options
      value: @_valueForMultiSelect @props.M
      multi: true
      placeholder: '-- Every Month --'
      onChange: @_handleChange.bind @, 'M'

  _dayOfWeekSelect: ->
    options = DAYS.map (value, key) ->
      value: "#{key + 1}"
      label: "#{value}"
    React.createElement Select,
      options: options
      value: @_valueForMultiSelect @props.d
      multi: true
      placeholder: '-- Every Week Day --'
      onChange: @_handleChange.bind @, 'd'

  _hourSelect: ->
    React.createElement Select,
      options: _.range(0, 24).map (value) ->
        value: "#{value}"
        label: lpad value, 2
      value: @_valueForMultiSelect @props.h
      multi: true
      placeholder: '-- Every Hour --'
      onChange: @_handleChange.bind @, 'h'

  _minuteSelect: ->
    React.createElement Select,
      options: _.range(0, 60).map (value) ->
        value: "#{value}"
        label: lpad value, 2
      value: @_valueForMultiSelect @props.m
      placeholder: '-- Every Minute --'
      multi: true
      onChange: @_handleChange.bind @, 'm'

  _valueForMultiSelect: (items) ->
    if items.length
      items.join ','
    else
      null

  _handleChange: (propName, newValue) ->
    @props.onChange propName, newValue

module.exports = React.createClass
  displayName: 'CronSchedulerWrapper'
  propTypes:
    crontabRecord: React.PropTypes.string.isRequired
    onChange: React.PropTypes.func.isRequired

  getInitialState: ->
    schedules = later.parse.cron(@props.crontabRecord)
    period: @_getPeriodForSchedule schedules.schedules[0]

  render: ->
    schedule = @_getSchedule()
    React.DOM.div null,
      React.createElement Scheduler,
        period: @state.period
        M: schedule.M || []
        D: schedule.D || []
        d: schedule.d || []
        h: schedule.h || []
        m: schedule.m || []
        next: @_getNext()
        onChange: @_handleChange
        onPeriodChange: @_handlePeriodChange


  _handleChange: (propName, newValue) ->
    schedule = @_getSchedule()
    if newValue
      schedule[propName] = _.unique newValue.split(',')
    else
      delete schedule[propName]
    @props.onChange @_scheduleToCron schedule

  _handlePeriodChange: (newValue) ->
    # change current schedule
    schedule = @_getSchedule()
    toDelete = []
    switch newValue
      when later.hour.name then toDelete = ['M', 'D', 'h', 'd']
      when later.day.name then toDelete = ['M', 'D', 'd']
      when later.dayOfWeek.name then toDelete = ['M', 'D']
      when later.month.name then toDelete = ['M', 'd']

    toDelete.forEach (key) ->
      delete schedule[key]

    @props.onChange @_scheduleToCron schedule

    @setState
      period: newValue

  _getPeriodForSchedule: (schedules) ->
    if schedules['M']
      return later.year.name
    if schedules['D']
      return later.month.name
    if schedules['d']
      return later.dayOfWeek.name
    if schedules['h']
      return later.day.name
    return later.hour.name

  _getSchedule: ->
    later.date.UTC()
    later.parse.cron(@props.crontabRecord).schedules[0]

  _getNext: ->
    later.schedule(later.parse.cron(@props.crontabRecord)).next 5

  _scheduleToCron: (schedule) ->
    flatten = (part) ->
      if !part
        return '*'
      else
        return _.sortBy part, (item) ->
          parseInt item
        .join ','

    flattenDayOfWeek = (part) ->
      if !part
        return '*'
      else
        return part
        .map (value) -> value - 1
        .join ','

    parts = []
    parts.push flatten schedule['m']
    parts.push flatten schedule['h']
    parts.push flatten schedule['D']
    parts.push flatten schedule['M']
    parts.push flattenDayOfWeek schedule['d']

    parts.join ' '
