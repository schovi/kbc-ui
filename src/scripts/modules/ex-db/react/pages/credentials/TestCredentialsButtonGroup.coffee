React = require 'react'
Button = React.createFactory(require('react-bootstrap').Button)


ExDbActionCreators = require '../../../exDbActionCreators.coffee'

{div} = React.DOM

module.exports = React.createClass
  displayName: 'TestCredentialsButtonGroup'
  propTypes:
    credentials: React.PropTypes.object.isRequired

  getInitialState: ->
    isTesting: false

  _startTesting: ->
    @setState
      isTesting: true

    ExDbActionCreators
    .testCredentials @props.credentials
    .then @_onTestingDone

  _onTestingDone: (job) ->
    @setState
      isTesting: false
    console.log 'done', job

  render: ->
    div className: 'form-group',
      div className: 'col-xs-offset-4 col-sx-8',
        Button
          bsStyle: 'primary'
          disabled: @state.isTesting
          onClick: @_startTesting
        ,
          'Test Credentials'