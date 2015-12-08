React = require 'react'
Input = React.createFactory(require('react-bootstrap').Input)
List = require('immutable').List
is3rdParty = require('../../../is3rdParty.js').default

require('./VendorInfo.less')

{div, label, ul, li, p, span, strong, address, a, br, em, table, tr, td, h2} = React.DOM
module.exports = React.createClass
  displayName: 'VendorInfo'
  propTypes:
    component: React.PropTypes.object.isRequired

  render: ->
    div className: "kbcVendorInfo",
      if (is3rdParty(@props.component))
        div null,
          "Component developed by"
          @_renderAddress()
      else
        null

  _renderAddress: ->
    contactData = @props.component.getIn(['data', 'vendor', 'contact'], 'No Address')
    firstLine = strong(null, contactData)
    restLines = null
    if List.isList(contactData)
      firstLine = strong(null, contactData.first())
      restLines = contactData.rest().map (line) ->
        span null,
          br()
          line
    address null,
      firstLine
      restLines
