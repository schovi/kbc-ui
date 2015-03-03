React = require 'react'

{span, div, strong} = React.DOM

RedshiftCredentials = React.createClass
  displayName: 'RedshiftCredentials'
  propTypes:
    credentials: React.PropTypes.object
      
  render: ->
    div {},
      div {className: 'row'},
        span {className: 'col-md-3'}, 'Host'
        strong {className: 'col-md-9'}, @props.credentials.getIn ["credentials", "hostname"]
      div {className: 'row'},
        span {className: 'col-md-3'}, 'Port'
        strong {className: 'col-md-9'}, '5403'
      div {className: 'row'},
        span {className: 'col-md-3'}, 'User'
        strong {className: 'col-md-9'}, @props.credentials.getIn ["credentials", "user"]
      div {className: 'row'},
        span {className: 'col-md-3'}, 'Password'
        strong {className: 'col-md-9'}, @props.credentials.getIn ["credentials", "password"]
      div {className: 'row'},
        span {className: 'col-md-3'}, 'Database'
        strong {className: 'col-md-9'}, @props.credentials.getIn ["credentials", "db"]
      div {className: 'row'},
        span {className: 'col-md-3'}, 'Schema'
        strong {className: 'col-md-9'}, @props.credentials.getIn ["credentials", "schema"]

module.exports = RedshiftCredentials
