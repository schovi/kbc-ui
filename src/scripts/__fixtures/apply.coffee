_ = require 'underscore'
ComponentsActionCreators = require '../modules/components/ComponentsActionCreators.coffee'
InstalledComponentsActionCreators = require '../modules/components/InstalledComponentsActionCreators.coffee'
OrchestrationsActionCreators = require '../modules/orchestrations/ActionCreators.coffee'

module.exports = (fixtures) ->
  _.forEach(fixtures, (data, name) ->
    switch name
      when 'components'
        ComponentsActionCreators.receiveAllComponents(data)

      when 'installedComponents'
        InstalledComponentsActionCreators.receiveAllComponents(data)

      when 'orchestrations'
        OrchestrationsActionCreators.receiveAllOrchestrations(data)
  )
