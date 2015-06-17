React = require 'react'
Input = React.createFactory(require('react-bootstrap').Input)
List = require('immutable').List

{div, label, ul, li, span, strong, address, a, br } = React.DOM
module.exports = React.createClass
  displayName: 'appVendorInfo'
  propTypes:
    vendorData: React.PropTypes.object.isRequired
    handleAgreedLicense: React.PropTypes.func.isRequired

  render: ->
    div className: 'form-group',
      label className: 'control-label col-xs-2', 'License'
      div className: 'col-xs-10',
        span null, 'This is a 3rd party application with the following terms and conditions:'
        ul null,
          li null, 'Extra money will be charged.'
          li null, 'Data may be sent out of Keboola Connection.'
          li null,
            'Vendor:'
            @_renderAddress()
          @_renderLicenseUrl()
        Input
          type: 'checkbox'
          label: 'I agree with the terms and conditions.'
          checked: @props.vendorData.get('agreed')
          wrapperClassName: 'col-xs-10'
          labelClassName: 'col-xs-10'
          onChange: (event) =>
            @props.handleAgreedLicense(event.target.checked)

  _renderLicenseUrl: ->
    licenseUrl = @props.vendorData.get 'licenseUrl'
    if not licenseUrl
      return null
    else
      li null,
        a {href: licenseUrl, target: '_blank'}, 'Vendor license terms and conditions.'


  _renderAddress: ->
    contactData = @props.vendorData.get 'contact'
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
