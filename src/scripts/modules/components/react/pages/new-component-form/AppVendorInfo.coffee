React = require 'react'
Input = React.createFactory(require('react-bootstrap').Input)

{div, label, ul, li, span, strong, address, p, br } = React.DOM
module.exports = React.createClass
  displayName: 'appVendorInfo'
  propTypes:
    vendorData: React.PropTypes.object.isRequired
    handleAgreedLicense: React.PropTypes.func.isRequired

  render: ->
    div className: 'form-group',
      label className: 'control-label col-xs-2', 'License'
      div className: 'col-xs-10',
        span null, 'This is a 3rd party application with the following terms and conditions'
        ul null,
          li null, 'Extra money will be charged.' #optional
          li null, 'Data may be sent out of Keboola Connection' #optional
          li null, 'Vendor license terms and conditions' #required
          li null,
            'Vendor:'
            @_renderAddress()
        Input
          type: 'checkbox'
          label: 'I agree with the terms and conditions.'
          checked: @props.vendorData.get('agreed')
          wrapperClassName: 'col-xs-10'
          labelClassName: 'col-xs-10'
          onChange: (event) =>
            @props.handleAgreedLicense(event.target.checked)

  _renderAddress: ->
    address null,
      strong null, 'Vendor name'
      br()
      "contact line"
      br()
      "contact line"
      br()
      "contact line"
