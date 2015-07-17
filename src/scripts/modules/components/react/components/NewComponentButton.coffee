React = require 'react'

{button, span} = React.DOM

InstalledComponentsStore = require '../../stores/InstalledComponentsStore'
InstalledComponentsActionCreators = require '../../InstalledComponentsActionCreators'
createStoreMixin = require '../../../../react/mixins/createStoreMixin'

Link = React.createFactory(require('react-router').Link)


createNewComponentButton = (text, to, type) ->

  NewComponentButton = React.createClass
    displayName: 'NewComponentButton'
    mixins: [createStoreMixin(InstalledComponentsStore)]

    getStateFromStores: ->
      hasInstalled: InstalledComponentsStore.getAllForType(type).count() > 0

    render: ->
      if @state.hasInstalled
        Link to: to, className: 'btn btn-success',
          span className: 'kbc-icon-plus'
          text
      else
        span null


module.exports = createNewComponentButton
