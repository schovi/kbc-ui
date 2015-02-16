assign = require 'object-assign'
Dispatcher = require('flux').Dispatcher
KbcConstants = require('./constants/KbcConstants')

PayloadSources = KbcConstants.PayloadSources

class KbcDispatcher extends Dispatcher

  handleViewAction: (action) ->
    console.log 'dispatch', action.type
    payload =
      source: PayloadSources.VIEW_ACTION
      action: action
    @dispatch(payload)


module.exports = new KbcDispatcher()