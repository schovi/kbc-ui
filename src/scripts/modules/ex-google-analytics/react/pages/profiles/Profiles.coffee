React = require 'react'
exGanalStore = require('../../../exGanalStore')
createStoreMixin = require '../../../../../react/mixins/createStoreMixin'
ExGanalActionCreators  = require '../../../exGanalActionCreators'
RoutesStore = require '../../../../../stores/RoutesStore'

ProfilesLoader = require('../../../../google-utils/react/ProfilesPicker').default
EmptyState = require('../../../../components/react/components/ComponentEmptyState').default
EmptyState = React.createFactory EmptyState
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
    console.log('avalaible PROFILES', @state.profiles?.toJS())
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
    profiles = @state.profiles?.get('profiles')
    email = @state.profiles?.get('email')
    div className: '',
      React.DOM.h2 null, "1. Load Google Account Profiles"
      @_renderProfilesLoader()
      if profiles == undefined
        EmptyState null, 'No profiles loaded.'
      else
        span null,
          React.DOM.h2 null, "2. Select Profiles of #{email}"
          PanelGroup accordion: true,
            if profiles and profiles.count() > 0
              profiles.map( (profileGroup, profileGroupName) =>
                @_renderProfileGroup(profileGroup, profileGroupName)
              ,@).toArray()
            else
              EmptyState null, 'The account has no profiles.'

  _renderProfilesLoader: ->
    div className: 'text-center',
      React.createElement ProfilesLoader,
        email: null
        onProfilesLoad: (profiles, email) =>
          console.log "loaded profiles", profiles

          ExGanalActionCreators.setLoadedProfiles(@state.configId, profiles, email)


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
        @_renderProfilePanel(profile, profileName, profileGroupName, profileGroup)
      ).toArray()


  _renderProfilePanel: (profile, profileName, profileGroupName, profileGroup) ->
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
      React.DOM.h2 className: '', "Selected Profiles To Extract Data from #{@state.config.get('email')}"
      if @state.selectedProfiles and @state.selectedProfiles.count() > 0
        @_renderProfilesItems(@state.selectedProfiles)
      else
        EmptyState null, 'No profiles selected.'

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
