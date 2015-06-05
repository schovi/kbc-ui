React = require 'react'
_ = require 'underscore'
ImmutableRendererMixin = require '../../react/mixins/ImmutableRendererMixin'
{DropdownButton, MenuItem, DropdownStateMixin} = require 'react-bootstrap'

{div, img, strong, span} = React.DOM

module.exports = React.createClass
  displayName: 'User'
  mixins: [ImmutableRendererMixin, DropdownStateMixin]
  propTypes:
    user: React.PropTypes.object.isRequired
    maintainers: React.PropTypes.object.isRequired
    urlTemplates: React.PropTypes.object.isRequired
    canManageApps: React.PropTypes.bool.isRequired
  render: ->
    div
      className: 'kbc-user'
      onClick: @_handleUserClick
    ,
      img
        src: @props.user.get 'profileImageUrl'
        className: 'kbc-user-avatar'
      ,
        div null,
          strong null, @props.user.get 'name'
          React.createElement DropdownButton,
            className: 'kbc-user-menu'
            bsStyle: 'link'
            dropup: true
            title: ''
            ref: 'dropdownButton'
          ,
            @_userLinks()
        div null,
          span null, @props.user.get 'email'

  _userLinks: ->
    links = []
    links.push React.createElement MenuItem,
      key: 'changePassword'
      href: @props.urlTemplates.get 'changePassword'
    ,
      'Change Password'

    if @props.canManageApps
      links.push React.createElement MenuItem,
        key: 'manageApps'
        href: @props.urlTemplates.get 'manageApps'
      ,
        'Manage Applications'

      links.push React.createElement MenuItem,
        key: 'syrupJobsMonitoring'
        href: @props.urlTemplates.get 'syrupJobsMonitoring'
      ,
        'Syrup Jobs Monitoring'

    if @props.maintainers.count()
      links.push React.createElement MenuItem,
        header: true
        key: 'maintainersHeader'
      ,
        'Maintainers'
      @props.maintainers.forEach (maintainer) ->
        links.push React.createElement MenuItem,
          href: @_maintainerUrl maintainer.get('id')
          key: maintainer.get 'id'
        ,
          maintainer.get 'name'
      , @

    links.push React.createElement MenuItem,
      key: 'logoutDivider'
      divider: true
    links.push React.createElement MenuItem,
      href: @props.urlTemplates.get 'logout'
      key: 'logout'
    ,
      'Logout'
    links

  _maintainerUrl: (id) ->
    _.template(@props.urlTemplates.get('maintainer'))(maintainerId: id)

  _handleUserClick: (e) ->
    @refs.dropdownButton.handleDropdownClick(e)
