React = require 'react'
date = require '../../../utils/date'
PureRendererMixin = require '../../../react/mixins/ImmutableRendererMixin'
{Link} = require 'react-router'
sapiEventsUtils = require '../utils'
classnames = require 'classnames'
_ = require 'underscore'

{div} = React.DOM

module.exports = React.createClass
  displayName: 'TableRow'
  mixins: [PureRendererMixin]
  propTypes:
    event: React.PropTypes.object.isRequired
    link: React.PropTypes.object.isRequired
  render: ->
    React.createElement Link,
      to: @props.link.to
      params: @props.link.params
      query: _.extend {}, @props.link.query,
        eventId: @props.event.get('id')
      className: classnames('tr', sapiEventsUtils.classForEventType(@props.event.get('type')))
    ,
      div className: 'td',
        date.format @props.event.get('created'),
      div className: 'td',
        @props.event.get('message')