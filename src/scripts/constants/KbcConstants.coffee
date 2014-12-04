keyMirror = require('react/lib/keyMirror')

module.exports =

  PayloadSources: keyMirror(
    SERVER_ACTION: null
    VIEW_ACTION: null
  )

  ActionTypes: keyMirror(
    # Components
    COMPONENTS_SET_FILTER: null
    COMPONENTS_LOAD_SUCCESS: null

    # Installed components
    INSTALLED_COMPONENTS_LOAD: null
    INSTALLED_COMPONENTS_LOAD_SUCCESS: null
    INSTALLED_COMPONENTS_LOAD_ERROR: null

    # Application state
    APPLICATION_DATA_RECEIVED: null

    # Router state
    ROUTER_ROUTE_CHANGE_START: null
    ROUTER_ROUTE_CHANGE_SUCCESS: null
    ROUTER_ROUTE_CHANGE_ERROR: null
    ROUTER_ROUTES_CONFIGURATION_RECEIVE: null
  )
