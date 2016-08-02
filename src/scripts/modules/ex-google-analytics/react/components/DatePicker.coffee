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
    dateFrom: React.PropTypes.string.isRequired
    dateUntil: React.PropTypes.string.isRequired

  getDefaultProps: ->
    from = moment().subtract(4, 'day')
    dateUntil = moment()
    dateFrom: from
    dateUntil: dateUntil

  render: ->
    daysRange = @props.dateUntil.from(@props.dateFrom, true)
    form className: 'form-horizontal',
      h3 {}, 'Specify date range'
      div className: 'form-group',
        label className: 'col-sm-3 control-label', 'From Date:'
        div className: 'col-sm-6',
          DatePicker
            key: 'fromdate'
            onChange: (value) =>
              @props.onChangeFrom(value)
            selected: @props.dateFrom
            maxDate: @props.dateUntil
            dateFormat: "DD/MM/YYYY"

      div className: 'form-group',
        label className: 'col-sm-3 control-label', 'Until Date:'
        div className: 'col-sm-6',
          DatePicker
            dateFormat: "DD/MM/YYYY"
            key: 'untildate'
            onChange: (value) =>
              @props.onChangeUntil(value)
            minDate: @props.dateFrom
            selected: @props.dateUntil
      div className: 'form-group',
        label className: 'col-sm-3 control-label', 'Set Range:'
        div className: 'col-sm-2',
          Button
            bsStyle: 'primary'
            onClick: =>
              @props.onChangeUntil(moment())
              @props.onChangeFrom(moment().subtract(7, 'day'))
          ,
            'Last 7 days'
        div className: 'col-sm-2',
          Button
            bsStyle: 'primary'
            onClick: =>
              @props.onChangeUntil(moment())
              @props.onChangeFrom(moment().date(1))
          ,
            'This month'
        div className: 'col-sm-3',
          Button
            bsStyle: 'primary'
            className: 'pull-left'
            onClick: =>
              @props.onChangeUntil(moment())
              @props.onChangeFrom(moment().subtract(30, 'day'))
          ,
            'Last 30 days'
      div className: 'form-group',
        label className: 'col-sm-3 control-label', 'Days in total'
        div className: 'col-sm-6',
          Input
            type: 'static'
            value: @props.dateUntil.diff(@props.dateFrom, 'days')
            onChange: (event) =>
              if parseInt(event.target.value) > -1
                @props.onChangeUntil(moment())
                @props.onChangeFrom(moment().subtract(event.target.value, 'day'))
