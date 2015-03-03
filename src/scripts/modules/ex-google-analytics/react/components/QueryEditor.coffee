React = require 'react'

Input = React.createFactory(require('react-bootstrap').Input)
{div, form, option, optgroup} = React.DOM

module.exports = React.createClass
  displayName: 'ExGanalQueryEditor'
  propTypes:
    configId: React.PropTypes.string.isRequired
    query: React.PropTypes.object.isRequired
    profiles: React.PropTypes.object.isRequired

  render: ->
    div {className: 'container-fluid kbc-main-content'},
      form className: 'form-horizontal',
        div className: 'row',
          @_createInput 'Name', 'name'
          @_createInput 'Filters', 'filters'

          @_profilesSelect()


  _profilesSelect: ->
    groups = @props.profiles.groupBy( (profile) ->
      profile.get('accountName') + '/ ' + profile.get('webPropertyName'))
    options = groups.map( (group, groupName) =>
      optgroup
        label: groupName
      ,
        group.map (item) ->
          option
            value: item.get 'googleId'
          ,
            item.get 'name'
    )
    return Input
      label: 'Profiles'
      labelClassName: 'col-xs-4'
      wrapperClassName: 'col-xs-8'
      type: 'select'
      onChange: (event) =>
        @props.onChange(@props.query.set('profile'), event.target.value)
    ,
      option
        value: ''
      ,
        '--all--'
      options

  _createInput: (caption, propName) ->
    Input
      label: caption
      type: 'text'
      value: @props.query.get(propName)
      labelClassName: 'col-xs-4'
      wrapperClassName: 'col-xs-8'
      onChange: (event) =>
        @props.onChange(@props.query.set(propName), event.target.value)
