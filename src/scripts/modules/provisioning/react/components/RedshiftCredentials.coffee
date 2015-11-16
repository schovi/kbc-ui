React = require 'react'

Protected = React.createFactory(require('kbc-react-components').Protected)
Clipboard = React.createFactory(require('../../../../react/common/Clipboard').default)
Loader = React.createFactory(require('kbc-react-components').Loader)
Input = React.createFactory(require('react-bootstrap').Input)

{span, div, strong, small} = React.DOM

RedshiftCredentials = React.createClass
  displayName: 'RedshiftCredentials'
  propTypes:
    credentials: React.PropTypes.object
    isCreating: React.PropTypes.bool

  getInitialState: ->
    showDetails: false

  render: ->
    div {},
      if @props.isCreating
        span {},
          Loader()
          ' Creating credentials'
      else
        if @props.credentials.get "id"
          @_renderCredentials()

        else
          'Credentials not found'

  _renderCredentials: ->
    jdbcRedshift = 'jdbc:redshift://' + @props.credentials.get("hostname") + ':5439/' + @props.credentials.get("db")
    jdbcPgSql = 'jdbc:postgresql://' + @props.credentials.get("hostname") + ':5439/' + @props.credentials.get("db")
    span {},
      div {className: 'row'},
        span {className: 'col-md-3'}, 'Host'
        strong {className: 'col-md-9'},
          @props.credentials.get "hostname"
          Clipboard text: @props.credentials.get "hostname"
      div {className: 'row'},
        span {className: 'col-md-3'}, 'Port'
        strong {className: 'col-md-9'},
          '5439'
          Clipboard text: '5439'
      div {className: 'row'},
        span {className: 'col-md-3'}, 'User'
        strong {className: 'col-md-9'},
          @props.credentials.get "user"
          Clipboard text: @props.credentials.get "user"
      div {className: 'row'},
        span {className: 'col-md-3'}, 'Password'
        strong {className: 'col-md-9'},
          Protected {},
            @props.credentials.get "password"
          Clipboard text: @props.credentials.get "password"
      div {className: 'row'},
        span {className: 'col-md-3'}, 'Database'
        strong {className: 'col-md-9'},
          @props.credentials.get "db"
          Clipboard text: @props.credentials.get "db"
      div {className: 'row'},
        span {className: 'col-md-3'}, 'Schema'
        strong {className: 'col-md-9'},
          @props.credentials.get "schema"
          Clipboard text: @props.credentials.get "schema"
      div {className: 'form-horizontal clearfix'},
        div {className: "row"},
          div className: 'form-group-sm',
            span {className: 'col-md-3'}, ''
              div className: 'col-md-9',
                Input
                  standalone: true
                  type: 'checkbox'
                  label: small {}, 'Show JDBC strings'
                  checked: @state.showDetails
                  onChange: @_handleToggleShowDetails
      if @state.showDetails
        div {className: 'row'},
          span {className: 'col-md-3'}, 'Redshift driver'
          strong {className: 'col-md-9'},
            jdbcRedshift
            Clipboard text: jdbcRedshift
      if @state.showDetails
        div {className: 'row'},
          span {className: 'col-md-3'}, 'PostgreSQL driver'
          strong {className: 'col-md-9'},
            jdbcPgSql
            Clipboard text: jdbcPgSql

  _handleToggleShowDetails: (e) ->
    @setState(
      showDetails: e.target.checked
    )

module.exports = RedshiftCredentials
