Promise = require 'bluebird'
parse = require 'csv-parse'


module.exports = (csvText) ->
  Promise
  .promisify(parse)(csvText)