
console.time('load')

React = require 'react'
Router = require 'react-router'
Promise = require 'bluebird'
_ = require 'underscore'
Immutable = require 'immutable'

routes = require './routes'
createReactRouterRoutes = require './utils/createReactRouterRoutes'
Timer = require './utils/Timer'
Error = require './utils/Error'

ApplicationActionCreators = require './actions/ApplicationActionCreators'
RouterActionCreators = require './actions/RouterActionCreators'


RoutesStore = require './stores/RoutesStore'
initializeData = require './initializeData'

###
  Bootstrap and start whole application
  appOptions:
    - data - initial data
    - rootNode - mount element
    - locationMode - hash or pushState location
###
console.timeEnd('load')
startApp = (appOptions) ->

  initializeData(appOptions.data)

  ApplicationActionCreators.receiveApplicationData(
    sapiUrl: appOptions.data.sapi.url
    sapiToken: appOptions.data.sapi.token
    organizations: appOptions.data.organizations
    maintainers: appOptions.data.maintainers
    kbc: appOptions.data.kbc
    tokenStats: appOptions.data.tokenStats
  )

  RouterActionCreators.routesConfigurationReceive(routes)

  router = Router.create(
    routes: createReactRouterRoutes(_.extend {}, routes,
      path: appOptions.data.kbc.projectBaseUrl
    )
    location: if appOptions.locationMode == 'history' then Router.HistoryLocation else Router.HashLocation
  )

  Promise.longStackTraces()
  # error thrown during application live not on route chage
  Promise.onPossiblyUnhandledRejection (e) ->
    error = Error.create(e)
    notification = "#{error.getTitle()}. #{error.getText()}"
    if error.getExceptionId()
      notification += " Exception id: #{error.getExceptionId()}"

    ApplicationActionCreators.sendNotification notification, 'error', error.id
    throw e

  # Show loading page before app is ready
  loading = _.once (Handler) ->
    React.render(React.createElement(Handler, isLoading: true), appOptions.rootNode)

  # registered pollers for previous page
  registeredPollers = Immutable.List()

  RouterActionCreators.routerCreated router

  # re-render after each route change
  router.run (Handler, state) ->
    # avoid state mutation by router
    state = _.extend {}, state,
      routes: _.map state.routes, (route) ->
        # convert to plain object
        _.extend {}, route

    RouterActionCreators.routeChangeStart(state)

    # run only once on first render
    loading(Handler)

    # stop pollers required by previous page
    registeredPollers.forEach((action) ->
      Timer.stop(action)
    )

    # async data handling inspired by https://github.com/rackt/react-router/blob/master/examples/async-data/app.js
    promises = RoutesStore
      .getRequireDataFunctionsForRouterState(state.routes)
      .map((requireData) ->
        requireData(state.params, state.query)
      ).toArray()

    # wait for data and trigger render
    Promise.all(promises)
    .then(->
      RouterActionCreators.routeChangeSuccess(state)
      React.render(React.createElement(Handler), appOptions.rootNode)

      # Start pollers for new page
      registeredPollers = RoutesStore
        .getPollersForRoutes(state.routes)
        .map((poller) ->
          callback = -> poller.get('action')(state.params)
          Timer.poll(callback, poller.get('interval'))
          return callback
        )

    ).catch((error) ->
      # render error page
      console.log 'route change error', error.message, error, error.stack
      RouterActionCreators.routeChangeError(error)
      React.render(React.createElement(Handler, isError: true), appOptions.rootNode)
    )

global.kbcApp =
  start: startApp
  helpers: require './helpers'