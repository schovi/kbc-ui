React = require 'react'
{span, div, a, p, h2} = React.DOM

module.exports = React.createClass

  displayName: 'GeneeaApp'

  getInitialState: ->
    {}

  render: ->
    console.log 'rendering geneea'
    div {}, 'GENEEA APP INDEX'
