React = require 'react'

{button, span} = React.DOM

InstalledComponentsStore = require '../../stores/InstalledComponentsStore'
InstalledComponentsActionCreators = require '../../InstalledComponentsActionCreators'
createStoreMixin = require '../../../../react/mixins/createStoreMixin'

Link = React.createFactory(require('react-router').Link)

module.exports = React.createClass
  displayName: 'NewComponentButton'
  mixins: [createStoreMixin(InstalledComponentsStore)]
  propTypes:
    type: React.PropTypes.string.isRequired
    to: React.PropTypes.string.isRequired
    text: React.PropTypes.string.isRequired

  getStateFromStores: ->
    hasInstalled: InstalledComponentsStore.getAllForType(@props.type).count() > 0

  render: ->
    if @state.hasInstalled
      Link
        to: @props.to
        className: 'btn btn-success'
        activeClassName: ''
      ,
        span className: 'kbc-icon-plus'
        @props.text
    else
      span null

