assign = require 'object-assign'
Dispatcher = require('flux').Dispatcher
KbcConstants = require('../constants/KbcConstants.coffee')

PayloadSources = KbcConstants.PayloadSources

class KbcDispatcher extends Dispatcher

  handleViewAction: (action) ->
    payload =
      source: PayloadSources.VIEW_ACTION
      action: action
    @dispatch(payload)


module.exports = new KbcDispatcher()