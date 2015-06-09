_ = require 'underscore'

module.exports = (componentId) ->
  isComplete: (data) ->
    console.log data.toJS() if data
    return false if not data
    return false if _.isEmpty(data.getIn(['storage', 'input', 'tables', 0, 'source']))
    return false if _.isEmpty(data.getIn(['storage', 'output', 'tables', 0, 'source']))
    return false if _.isEmpty(data.getIn(['parameters', 'id_column']))
    return false if _.isEmpty(data.getIn(['parameters', 'data_column']))
    return true
