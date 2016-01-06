keyMirror = require('keyMirror')

module.exports =

  PayloadSources: keyMirror(
    SERVER_ACTION: null
    VIEW_ACTION: null
  )

  ActionTypes: keyMirror(

    # Application state
    APPLICATION_DATA_RECEIVED: null
    APPLICATION_SEND_NOTIFICATION: null
    APPLICATION_DELETE_NOTIFICATION: null
    APPLICATION_SET_PAUSE_NOTIFICATION: null

    # Router state
    ROUTER_ROUTE_CHANGE_START: null
    ROUTER_ROUTE_CHANGE_SUCCESS: null
    ROUTER_ROUTE_CHANGE_ERROR: null
    ROUTER_ROUTES_CONFIGURATION_RECEIVE: null
    ROUTER_ROUTER_CREATED: null
  )
