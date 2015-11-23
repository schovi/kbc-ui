React = require 'react'

FormHeader = React.createFactory(require './FormHeader')
Input = React.createFactory(require('react-bootstrap').Input)
AppVendorInfo = React.createFactory(require './AppVendorInfo')
AppUsageInfo = React.createFactory(require './AppUsageInfo')
{div, form} = React.DOM



module.exports = React.createClass
  displayName: 'NewComponentDefaultForm'
  propTypes:
    component: React.PropTypes.object.isRequired
    configuration: React.PropTypes.object.isRequired
    onCancel: React.PropTypes.func.isRequired
    onSave: React.PropTypes.func.isRequired
    onChange: React.PropTypes.func.isRequired
    isValid: React.PropTypes.bool.isRequired
    isSaving: React.PropTypes.bool.isRequired


  componentDidMount: ->
    @refs.name.getInputDOMNode().focus()


  _handleChange: (propName, event) ->
    @props.onChange(@props.configuration.set propName, event.target.value)

  render: ->
    form className: 'form-horizontal', onSubmit: @_handleSubmit,
      FormHeader
        component: @props.component
        onCancel: @props.onCancel
        onSave: @props.onSave
        isValid: @props.isValid and @_isLicenseAgreed()
        isSaving: @props.isSaving
      div className: 'row',
        div className: 'col-md-8',
          Input
            type: 'text'
            label: 'Name'
            ref: 'name'
            value: @props.configuration.get 'name'
            placeholder: "My #{@props.component.get('name')}"
            labelClassName: 'col-xs-2'
            wrapperClassName: 'col-xs-10'
            onChange: @_handleChange.bind @, 'name'
            disabled: @props.isSaving
          Input
            type: 'textarea'
            label: 'Description'
            value: @props.configuration.get 'description'
            labelClassName: 'col-xs-2'
            wrapperClassName: 'col-xs-10'
            onChange: @_handleChange.bind @, 'description'
            disabled: @props.isSaving
          @_renderAppUsageInfo() if @_is3rdPartyApp()
          @_renderAppVendorInfo() if @_is3rdPartyApp()

  vendorInfoPath: ['data','vendor']

  _renderAppVendorInfo: ->
    vendorData = @props.component.getIn(@vendorInfoPath)
    AppVendorInfo
      vendorData: vendorData
      licenseAgreed: @_isLicenseAgreed()
      handleAgreedLicense: @_setAgreedLicense

  _renderAppUsageInfo: ->
    licenseUrl = @props.component.getIn(@vendorInfoPath).get("licenseUrl")
    AppUsageInfo
      licenseUrl: licenseUrl


  _is3rdPartyApp: ->
    @props.component.hasIn(@vendorInfoPath) || @props.component.get('flags').contains('3rdParty')

  _isLicenseAgreed: ->
    # if is not 3rdparty app then license is always agreed by default
    if not @_is3rdPartyApp()
      return true
    agreed = @props.configuration.get('agreed')
    return  agreed or false

  _setAgreedLicense: (checked) ->
    #@props.onChange(@props.configuration.setIn(@vendorInfoPath, newData))
    @props.onChange(@props.configuration.set 'agreed', checked)

  _handleSubmit: (e) ->
    e.preventDefault()
    if @props.isValid and @_isLicenseAgreed()
      @props.onSave()
