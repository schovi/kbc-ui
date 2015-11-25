React = require 'react'
Input = React.createFactory(require('react-bootstrap').Input)
List = require('immutable').List
VendorInfo = React.createFactory(require '../component-detail/VendorInfo.coffee')

{div, label, ul, li, p, span, strong, address, a, br, em, table, tr, td, h2} = React.DOM
module.exports = React.createClass
  displayName: 'appVendorInfo'
  propTypes:
    component: React.PropTypes.object.isRequired
    licenseAgreed: React.PropTypes.bool.isRequired
    handleAgreedLicense: React.PropTypes.func.isRequired

  render: ->
    div className: 'form-group',
      label className: 'control-label col-xs-2', 'Vendor'
      div className: 'col-xs-10',
        VendorInfo
        div null,
          "Application developed by"
          @_renderAddress()
        Input
          type: 'checkbox'
          label: @_renderCheckboxLabel()
          checked: @props.licenseAgreed
          wrapperClassName: 'col-xs-10'
          labelClassName: 'col-xs-10'
          onChange: (event) =>
            @props.handleAgreedLicense(event.target.checked)

  _renderCheckboxLabel: ->
    licenseUrl = @props.component.getIn(['data', 'vendor', 'licenseUrl'], null)
    msg = 'I agree with these terms and conditions'
    if not licenseUrl
      return "#{msg}."
    else
      span null,
        "#{msg} and with "
        a {href: licenseUrl, target: '_blank'}, "vendor license terms and conditions."


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
