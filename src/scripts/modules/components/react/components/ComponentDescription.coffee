React = require 'react'

createStoreMixin = require '../../../../react/mixins/createStoreMixin.coffee'
InstalledComponentsStore = require '../../stores/InstalledComponentsStore.coffee'
InstalledComponentsActionCreators = require '../../InstalledComponentsActionCreators.coffee'

InlineEditArea = React.createFactory(require '../../../../react/common/InlineEditArea.coffee')

{button, span} = React.DOM


module.exports = React.createClass
  displayName: 'ComponentDescription'
  mixins: [createStoreMixin(InstalledComponentsStore)]
  propTypes:
    componentId: React.PropTypes.string.isRequired
    configId: React.PropTypes.string.isRequired

  getStateFromStores: ->
    config: InstalledComponentsStore.getConfig @props.componentId, @props.configId

  _handleSave: (newDescription) ->
    InstalledComponentsActionCreators.updateComponentConfiguration @props.componentId, @props.configId,
        description: newDescription


  render: ->
    InlineEditArea
      text: @state.config.get 'description'
      onSave: @_handleSave

