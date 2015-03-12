React = require 'react'
DatePicker = React.createFactory require('react-datepicker')
moment = require 'moment'
Input = React.createFactory(require('react-bootstrap').Input)
{div, p, strong, form, input, label, h3} = React.DOM
Button = React.createFactory(require('react-bootstrap').Button)

module.exports = React.createClass
  displayName: 'exGanalDatePicker'
  propTypes:
    onChangeFrom: React.PropTypes.func.isRequired
    onChangeUntil: React.PropTypes.func.isRequired

  getInitialState: ->
    from = moment().subtract(4, 'day')
    dateUntil = moment()
    dateFrom: @props.since or from
    dateUntil: @props.until or dateUntil

  render: ->
    daysRange = @state.dateUntil.from(@state.dateFrom, true)
    form className: 'form-horizontal',
      h3 {}, 'Specify date range'
      div className: 'form-group',
        label className: 'col-sm-3 control-label', 'From Date:'
        div className: 'col-sm-6',
          DatePicker
            key:'fromdate'
            onChange: (value) =>
              @setState
                dateFrom: value
              @props.onChangeFrom(value)
            selected: @state.dateFrom
            maxDate: @state.dateUntil
            dateFormat: "DD/MM/YYYY"

      div className: 'form-group',
        label className: 'col-sm-3 control-label', 'Until Date:'
        div className: 'col-sm-6',
          DatePicker
            dateFormat: "DD/MM/YYYY"
            key:'untildate'
            onChange: (value) =>
              @setState
                dateUntil: value
              @props.onChangeUntil(value)
            minDate: @state.dateFrom
            selected: @state.dateUntil
      div className: 'form-group',
        label className: 'col-sm-3 control-label', 'Set Range:'
        div className: 'col-sm-2',
          Button
            bsStyle: 'primary'
            onClick: =>
              @setState
                dateUntil: moment()
                dateFrom: moment().subtract(7, 'day')
          ,
            'Last 7 days'
        div className: 'col-sm-2',
          Button
            bsStyle: 'primary'
            onClick: =>
              @setState
                dateUntil: moment()
                dateFrom: moment().date(1)
          ,
            'This month'
        div className: 'col-sm-3',
          Button
            bsStyle: 'primary'
            className: 'pull-left'
            onClick: =>
              @setState
                dateUntil: moment()
                dateFrom: moment().subtract(30, 'day')
          ,
            'Last 30 days'
      div className: 'form-group',
        Input
          label: 'days until today'
          wrapperClassName: 'col-sm-offset-3 col-sm-3'
          type: 'number'
          value: @state.dateUntil.diff(@state.dateFrom, 'days')
          onChange: (event) =>
            if parseInt(event.target.value) > -1
              @setState
                dateUntil: moment()
                dateFrom: moment().subtract(event.target.value, 'day')

      # Input
      #   label: 'Date Range'
      #   type: 'static'
      #   value: daysRange
      #   labelClassName: 'col-sm-3'
      #   wrapperClassName: 'col-sm-6'
