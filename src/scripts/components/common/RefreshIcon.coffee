React = require 'react'
_ = require 'underscore'


RefreshIcon = React.createClass
  DisplayName: 'refreshIcon'

  render: ->
    classes = 'kbc-refresh kbc-icon-cw'
    if @props.isLoading
      classes += ' fa-spin'

    props = _.extend {}, _.omit(@props, 'isLoading'), {className: classes}
    React.DOM.span props

module.exports = RefreshIcon