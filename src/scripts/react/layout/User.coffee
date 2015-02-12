React = require 'React'
ImmutableRendererMixin = require '../../react/mixins/ImmutableRendererMixin.coffee'

{div, img, strong, span} = React.DOM

module.exports = React.createClass
  displayName: 'User'
  mixins: [ImmutableRendererMixin]
  propTypes:
    user: React.PropTypes.object.isRequired
  render: ->
    div className: 'kbc-user',
      img
        src: @props.user.get 'profileImageUrl'
        className: 'kbc-user-avatar'
      ,
        div null,
          strong null, @props.user.get 'name'
        div null,
          span null, @props.user.get 'email'
