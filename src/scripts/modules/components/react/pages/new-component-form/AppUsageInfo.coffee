React = require 'react'

{div, label, ul, li, p, span, strong, address, a, br, em, table, tr, td, h2} = React.DOM
module.exports = React.createClass
  displayName: 'appUsageInfo'
  propTypes:
    licenseUrl: React.PropTypes.object.isRequired

  render: ->
    div className: 'form-group',
      label className: 'control-label col-xs-2', 'License'
      div className: 'col-xs-10',
        table null,
          tr null,
            td null,
              em {className: "fa fa-cloud fa-fw kbcLicenseIcon"}
            td null,
              'This is a 3rd party application'
          tr null,
            td null,
              em {className: "fa fa-money fa-fw kbcLicenseIcon"}
            td null,
              'An extra fee may be charged'
          tr null,
            td null,
              em {className: "fa fa-external-link-square fa-fw kbcLicenseIcon"}
            td null,
              'Data may be sent out of Keboola Connection'
          tr null,
            td null,
              em {className: "fa fa-life-ring fa-fw kbcLicenseIcon"}
            td null,
              'Keboola does not take any responsibility for this application and support is not provided by Keboola'
          tr null,
            td null,
              em {className: "fa fa-file-text-o fa-fw kbcLicenseIcon"}
            td null,
              'You agree to '
              a {href: @props.licenseUrl},
                'vendor\'s license agreement'
