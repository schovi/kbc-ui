React = require 'react'
is3rdParty = require('../../../is3rdParty.js').default

{div, label, ul, li, p, span, strong, address, a, br, em, table, tr, td, h2} = React.DOM

module.exports = React.createClass
  displayName: 'appUsageInfo'
  propTypes:
    component: React.PropTypes.object.isRequired

  renderFeatures: ->
    features = []

    if (is3rdParty(@props.component))
      features.push tr {key: "3rdParty"},
        td null,
          em {className: "fa fa-cloud fa-fw kbcLicenseIcon"}
        td null,
          'This is a 3rd party component'

    if (@props.component.get("flags").contains("appInfo.fee"))
      features.push tr {key: "fee"},
        td null,
          em {className: "fa fa-money fa-fw kbcLicenseIcon"}
        td null,
          'An extra fee will be charged'

    if (@props.component.get("flags").contains("appInfo.dataIn"))
      features.push tr {key: "dataIn"},
        td null,
          em {className: "fa fa-cloud-download fa-fw kbcLicenseIcon"}
        td null,
          'Data from external sources will be ingested into Keboola Connection'

    if (@props.component.get("flags").contains("appInfo.dataOut"))
      features.push tr {key: "dataOut"},
        td null,
          em {className: "fa fa-cloud-upload fa-fw kbcLicenseIcon"}
        td null,
          'Data will be sent out of Keboola Connection'

    if (is3rdParty(@props.component))
      features.push tr {key: "responsibility"},
        td null,
          em {className: "fa fa-life-ring fa-fw kbcLicenseIcon"}
        td null,
          'Keboola does not take any responsibility for this component and support is not provided by Keboola'

    if (!is3rdParty(@props.component))
      features.push tr {key: "responsibility"},
        td null,
          em {className: "fa fa-life-ring fa-fw kbcLicenseIcon"}
        td null,
          'Keboola is responsible for this component and support is provided by Keboola'

    if (@props.component.getIn(['vendor', 'licenseUrl']))
      features.push tr {key: "license"},
        td null,
          em {className: "fa fa-file-text-o fa-fw kbcLicenseIcon"}
        td null,
          'You agree to '
          a {href: @props.component.getIn(['vendor', 'licenseUrl'])},
            'vendor\'s license agreement'

    return features

  render: ->
    table {className: "kbcLicenseTable"},
      @renderFeatures()
