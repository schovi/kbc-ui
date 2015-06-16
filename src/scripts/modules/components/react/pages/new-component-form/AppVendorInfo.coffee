React = require 'react'

{div} = React.DOM
module.exports = React.createClass
  displayName: 'appVendorInfo'
  propTypes:
    data: React.PropTypes.object

  render: ->
    div null, "vendor info"
