_ = require 'underscore'
ComponentsActionCreators = require './modules/components/ComponentsActionCreators'
InstalledComponentsActionCreators = require './modules/components/InstalledComponentsActionCreators'
OrchestrationsActionCreators = require './modules/orchestrations/ActionCreators'

module.exports = (initialData) ->
  _.forEach(initialData, (data, name) ->
    switch name
      when 'components'
        ComponentsActionCreators.receiveAllComponents(data)

      when 'installedComponents'
        InstalledComponentsActionCreators.receiveAllComponents(data)

      when 'orchestrations'
        OrchestrationsActionCreators.receiveAllOrchestrations(data)
  )
