React = require 'react'

InstalledComponentsStore = require '../../stores/InstalledComponentsStore'
InstalledComponentsActionCreators = require '../../InstalledComponentsActionCreators'
createStoreMixin = require '../../../../react/mixins/createStoreMixin'

Confirm = require('../../../../react/common/Confirm').default
{Loader} = require 'kbc-react-components'

module.exports = React.createClass
  displayName: 'DeleteConfigurationButton'
  mixins: [createStoreMixin(InstalledComponentsStore)]
  propTypes:
    preDeleteFn: React.PropTypes.func
    postDeleteFn: React.PropTypes.func
    componentId: React.PropTypes.string.isRequired
    configId: React.PropTypes.string.isRequired

  getStateFromStores: ->
    config: InstalledComponentsStore.getConfig(@props.componentId, @props.configId)
    isDeleting: InstalledComponentsStore.isDeletingConfig @props.componentId, @props.configId, @props.fieldName

  _handleDelete: ->
    if @props.preDeleteFn
      @props.preDeleteFn()
    InstalledComponentsActionCreators.deleteConfiguration(@props.componentId, @props.configId, true)
    .then =>
      if @props.postDeleteFn
        @props.postDeleteFn()



  render: ->
    React.createElement Confirm,
      text: 'Do you really want to delete the configuration?'
      title: 'Delete Configuration'
      buttonLabel: 'Delete'
      onConfirm: @_handleDelete
    ,
      React.DOM.a null,
        @_renderIcon()
        ' Delete'

  _renderIcon: ->
    if @state.isDeleting
      React.createElement Loader
    else
      React.DOM.span className: 'kbc-icon-cup fa fa-fw'
