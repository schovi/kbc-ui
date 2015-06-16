React = require 'react'
Input = React.createFactory(require('react-bootstrap').Input)

{div, label, ul, li, span, strong, address, p, br } = React.DOM
module.exports = React.createClass
  displayName: 'appVendorInfo'
  propTypes:
    data: React.PropTypes.object

  render: ->
    div className: 'form-group',
      label className: 'control-label col-xs-2', 'License'
      div className: 'col-xs-10',
        address null,
          strong null, "Vendor name"
          br()
          "contact line"
          br()
          "contact line"
          br()
          "contact line"

        span null, 'This is a 3rd party application with the following terms and conditions'
        ul null,
          li null, 'Extra money will be charged.' #optional
          li null, 'Data may be sent out of Keboola Connection' #optional
          li null, 'Vendor license terms and conditions' #required
        Input
          type: 'checkbox'
          label: 'I agree with the terms and conditions.'
          wrapperClassName: 'col-xs-10'
          labelClassName: 'col-xs-10'
          onChange: (event) ->
            console.log "changed", event.target.checked
