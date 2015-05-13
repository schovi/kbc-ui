
Dispatcher = require('../../../Dispatcher')
Constants = require '../Constants'
Immutable = require('immutable')
Map = Immutable.Map
_ = require 'underscore'
camelize = require 'underscore.string/camelize'
fuzzy = require 'fuzzy'
StoreUtils = require '../../../utils/StoreUtils'
ApplicationStore = require '../../../stores/ApplicationStore'

_store = Map(
  components: Map()
  filter: Map()
)

ComponentsStore = StoreUtils.createStore

  getAll: ->
    _store.get 'componentsById'

  getAllForType: (type) ->
    _store.get('componentsById').filter((component) ->
      component.get('type') == type
    )

  getComponent: (id) ->
    _store.getIn ['componentsById', id]

  hasComponent: (id) ->
    _store.hasIn ['componentsById', id]

  getFilteredForType: (type) ->
    filter = @getFilter(type)
    all = @getAllForType(type)
    all.filter((component) -> fuzzy.match(filter, component.get 'name'))

  getFilter: (type) ->
    _store.getIn(['filter', type]) || ''

  hasComponentLegacyUI: (id) ->
    _store.getIn(['componentsById', id], Map()).get 'hasUI'

  getComponentDetailLegacyUrl: (id, configurationId) ->
    component = @getComponent id

    if component.get('type') == 'extractor'
      templateName = 'legacyExtractorDetail'
    else
      templateName = 'legacyWriterDetail'

    template = ApplicationStore.getUrlTemplates().get templateName
    _.template(template)(
      projectId: ApplicationStore.getCurrentProjectId()
      appId: "kbc." + camelize(id)
      configId: configurationId
    )

  unknownComponent: (name) ->
    Map
      id: name
      name: name
      type: 'unknown'

Dispatcher.register (payload) ->
  action = payload.action

  switch action.type
    when Constants.ActionTypes.COMPONENTS_SET_FILTER
      _store = _store.setIn ['filter', action.componentType], action.query.trim()
      ComponentsStore.emitChange()

    when Constants.ActionTypes.COMPONENTS_LOAD_SUCCESS
      _store = _store.set 'componentsById', Immutable.fromJS(action.components).toMap().mapKeys((key, component) ->
        component.get 'id'
      )
      ComponentsStore.emitChange()


module.exports = ComponentsStore