React = require 'react'
exGanalStore = require('../../../exGanalStore')
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
ExGanalActionCreators  = require '../../../exGanalActionCreators'
RoutesStore = require '../../../../../stores/RoutesStore'

{Panel, PanelGroup, ListGroup, ListGroupItem} = require('react-bootstrap')
Accordion = React.createFactory(require('react-bootstrap').Accordion)
Panel  = React.createFactory Panel
PanelGroup = React.createFactory PanelGroup
ListGroup = React.createFactory ListGroup
ListGroupItem = React.createFactory ListGroupItem

{span, h3, div, form} = React.DOM

module.exports = React.createClass
  displayName: 'ExGanalProfiles'
  mixins: [createStoreMixin(exGanalStore)]

  getStateFromStores: ->
    configId = RoutesStore.getRouterState().getIn ['params', 'config']
    name = RoutesStore.getRouterState().getIn ['params', 'name']
    config = exGanalStore.getConfig(configId)
    configLoaded = exGanalStore.hasConfig configId
    config: config
    configId: configId
    isConfigLoaded: configLoaded
    profiles: exGanalStore.getProfiles(configId)
    selectedProfiles: exGanalStore.getSelectedProfiles(configId)

  render: ->
    if @state.isConfigLoaded and @state.config
      div {className: 'container-fluid kbc-main-content'},
        div {className: 'table kbc-table-border-vertical kbc-detail-table'},
          div {className: 'tr'},
            div {className: 'td'},
              @_renderProfiles()
            div {className: 'td'},
              @_renderProjectProfiles()
    else
      div {}, 'Loading ...'

  _renderProfiles: ->
    div className: '',
      React.DOM.h2 className: '', "Available Profiles of #{@state.config.get('email')}"
      PanelGroup accordion: true,
        if @state.profiles and @state.profiles.count() > 0
          @state.profiles.map( (profileGroup, profileGroupName) =>
            @_renderProfileGroup(profileGroup, profileGroupName)
          ,@).toArray()
        else
          div className: 'well', 'No Profiles.'

  _renderProfileGroup: (profileGroup, profileGroupName) ->
    header = div
      className: ''
      profileGroupName
    Panel
      header: header
      key: profileGroupName
      eventKey: profileGroupName,
    ,
      profileGroup.map( (profile, profileName) =>
        @_renderProfilePanel(profile, profileName, profileGroupName)
      ).toArray()


  _renderProfilePanel: (profile, profileName, profileGroupName) ->
    header = div
      className: ''
      profileName
    PanelGroup accordion: true,
      Panel
        header: header
        key: profileName
        eventKey: profileName
      ,
        div {className: 'row'},
          ListGroup {},
            profile.map((profileItem) =>
              ListGroupItem
                className: ''
                active: @_isSelected(profileItem.get('id'))
                onClick: =>
                  profileItem = profileItem.set 'webPropertyName', profileName
                  profileItem = profileItem.set 'accountName', profileGroupName
                  profileItem = profileItem.set 'googleId', profileItem.get 'id'
                  @_profileOnClick(profileItem)
                ,
                  profileItem.get 'name'
            ).toArray()

  _profileOnClick: (profile) ->
    if @_isSelected(profile.get 'id')
      ExGanalActionCreators.deselectProfile(@state.configId, profile)
    else
      ExGanalActionCreators.selectProfile(@state.configId, profile)

  _isSelected: (profileId) ->
    @state.selectedProfiles and @state.selectedProfiles.has profileId

  _renderProjectProfiles: ->
    div className: '',
      React.DOM.h2 className: '', 'Selected Profiles'
      if @state.selectedProfiles
        @_renderProfilesItems(@state.selectedProfiles)
      else
        div className: 'well', 'No profiles selected in project.'

  _renderProfilesItems: (profiles) ->
    React.DOM.ul {},
      profiles.map((profile) =>
        profilePath = @_getProfilePath profile
        React.DOM.li
          key: profile.get 'googleId'
          span {},
            profilePath
            ' '
            span
              onClick: =>
                @_profileOnClick(profile)
              className: 'kbc-icon-cup kbc-cursor-pointer', ''

        ).toArray()

  _getProfilePath: (profile) ->
    account = profile.get 'accountName'
    webPropertyName = profile.get 'webPropertyName'
    name = profile.get 'name'
    return "#{account}/ #{webPropertyName}/ #{name}"
