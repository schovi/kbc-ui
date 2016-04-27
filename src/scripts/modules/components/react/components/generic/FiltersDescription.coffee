React = require 'react'
Immutable = require 'immutable'
{span, div, p, ul, li, strong} = React.DOM

module.exports = React.createClass
  displayName: 'FiltersDescription'
  propTypes:
    value: React.PropTypes.object.isRequired
    rootClassName: React.PropTypes.string

  getDefaultProps: ->
    rootClassName: 'col-md-6'

  render: ->
    span {className: @props.rootClassName},
      if @props.value.get('where_column')
        span {},
          'Where '
          strong {},
            @props.value.get('where_column')
          ' '
          @props.value.get('where_operator')
          ' '
          strong {},
            @props.value.get('where_values', Immutable.List()).map((value) ->
              if value == ''
                return '[empty string]'
              if value == ' '
                return '[space character]'
              return value
            ).join(', ')
      if @props.value.get('days', 0) != 0 && @props.value.get('where_column')
        ' and '
      if @props.value.get('days', 0) != 0
        span {},
          if @props.value.get('where_column')
            'changed in last '
          else
            'Changed in last '
          @props.value.get('days', 0)
          ' days'
      if @props.value.get('days', 0) == 0 && !@props.value.get('where_column')
        'N/A'
