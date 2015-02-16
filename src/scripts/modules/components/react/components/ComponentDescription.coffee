React = require 'react'

createStoreMixin = require '../../../../react/mixins/createStoreMixin'
InstalledComponentsStore = require '../../stores/InstalledComponentsStore'
InstalledComponentsActionCreators = require '../../InstalledComponentsActionCreators'

InlineEditArea = React.createFactory(require '../../../../react/common/InlineEditArea')

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
      placeholder: 'Describe the component ...'
      onSave: @_handleSave

