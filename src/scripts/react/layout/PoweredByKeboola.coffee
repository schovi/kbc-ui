React = require 'react'
ImmutableRendererMixin = require '../../react/mixins/ImmutableRendererMixin'
ApplicationStore = require '../../stores/ApplicationStore'

{div, small} = React.DOM

module.exports = React.createClass
  displayName: 'PoweredByKeboola'
  mixins: [ImmutableRendererMixin]

  render: ->
    if (ApplicationStore.hasCurrentProjectFeature('ui-snowflake-demo'))
      div className: 'kbc-powered-by',
        div null
          small null,
            ' Powered by Keboola Connection'
    else
      return null


