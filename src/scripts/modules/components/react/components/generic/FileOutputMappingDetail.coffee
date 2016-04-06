React = require 'react'
Link = React.createFactory(require('react-router').Link)
ImmutableRenderMixin = require '../../../../../react/mixins/ImmutableRendererMixin'
Check = React.createFactory(require('kbc-react-components').Check)
ListGroup = React.createFactory(require('react-bootstrap').ListGroup)
ListGroupItem = React.createFactory(require('react-bootstrap').ListGroupItem)
_ = require('underscore')

{span, div, a, button, i, h4, small, em, ul, li, strong, code} = React.DOM
numeral = require 'numeral'
Immutable = require 'immutable'

FileOutputMappingDetail = React.createClass(
  displayName: 'FileOutputMappingDetail'
  mixins: [ImmutableRenderMixin]

  propTypes:
    value: React.PropTypes.object.isRequired

  render: ->
    ListGroupItems = [
      ListGroupItem {key: 'source'},
        strong {className: "col-md-4"},
          'Source'
        span {className: "col-md-6"},
          'out/files/'
          @props.value.get('source')
      ListGroupItem {key: 'tags'},
        strong {className: "col-md-4"},
          'Tags'
        span {className: "col-md-6"},
          if @props.value.get('tags').count()
            @props.value.get('tags').map((tag) ->
              span
                className: "label kbc-label-rounded-small label-default"
                key: tag
              ,
                tag
            ).toArray()
          else
            'N/A'
      ListGroupItem {key: 'is-public'},
        strong {className: "col-md-4"},
          'Is public'
        span {className: "col-md-6"},
          Check
            isChecked: @props.value.get('is_public')
      ListGroupItem {key: 'is-permanent'},
        strong {className: "col-md-4"},
          'Is permanent'
        span {className: "col-md-6"},
          Check
            isChecked: @props.value.get('is_permanent')
    ]
    ListGroup {className: "clearfix"}, _.reject(ListGroupItems, (obj) -> obj == undefined)
)

module.exports = FileOutputMappingDetail
