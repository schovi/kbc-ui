React = require 'react'
Immutable = require 'immutable'
request = require './utils/request'

module.exports =
  getUrlParameterByName: (name, searchString) ->
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")
    regex = new RegExp("[\\?&]" + name + "=([^&#]*)")
    results = regex.exec(searchString)
    (if not results? then "" else decodeURIComponent(results[1].replace(/\+/g, " ")))
  React: React
  Immutable: Immutable
  request: request