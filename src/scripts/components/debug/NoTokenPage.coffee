React = require 'React'

{div, a, p, h1, input, form, button, strong} = React.DOM

NoTokenPage = React.createClass
  displayName: 'NoTokenPage'

  getInitialState: ->
    token: ''

  _setToken: (event) ->
    @setState
      token: event.target.value.trim()

  _useToken: (event) ->
    event.preventDefault()
    return if !@state.token
    window.location.href = "/?token=#{@state.token}#/"

  render: ->
    div className: 'container-fluid',
      div className: 'row',
        div className: 'col-md-12',
          h1 null, 'Keboola Connection UI Devel'
          p null, 'Storage API token is required in development mode. Please obtain one from Keboola.'
          p null,
            strong null, 'Please enter your token:'
            form className: 'form-inline', onSubmit: @_useToken,
              div className: 'form-group',
                input className: 'form-control input-sm', onChange: @_setToken, value: @state.token, style: {width: '400px'}
              ' '
              button className: 'btn btn-primary', 'Use token'


module.exports = NoTokenPage
