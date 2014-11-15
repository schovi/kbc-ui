React = require('react')
Header = React.createFactory require './Header.coffee'
_ = require 'underscore'

data = ['neco', 'druha', 'treti', 'pata']

App = React.createClass
    displayName: 'App'
    rows: ->
      _.map(data, (name) ->
        Header name: name
      )
    render: ->
      React.DOM.div null, @rows()


module.exports = App