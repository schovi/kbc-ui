React = require 'react'
Loader = React.createFactory(require('kbc-react-components').Loader)

###
  Loading indicator is shown after few milisecond. Loader is not required for fast transitions.
###

RoutePendingIndicator = React.createClass
  displayName: 'RoutePendingIndicator'
  props:
    timeout: React.PropTypes.int

  getInitialState: ->
    isShown: false

  getDefaultProps: ->
    timeout: 300

  componentDidMount: ->
    @timeout = setTimeout @showIndicator, @props.timeout

  componentWillUnmount: ->
    clearInterval @timeout

  render: ->
    if @state.isShown
      Loader()
    else
      null

  showIndicator: ->
    @setState isShown: true


module.exports = RoutePendingIndicator

