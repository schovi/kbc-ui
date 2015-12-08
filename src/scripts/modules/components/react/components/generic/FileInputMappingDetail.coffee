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

FileInputMappingDetail = React.createClass(
  displayName: 'FileInputMappingDetail'
  mixins: [ImmutableRenderMixin]

  propTypes:
    value: React.PropTypes.object.isRequired

  render: ->
    ListGroupItems = [
      ListGroupItem {key: 'tags'},
        strong {className: "col-md-4"},
          'Tags'
        span {className: "col-md-6"},
          if @props.value.get('tags', Immutable.List()).count()
            @props.value.get('tags', Immutable.List()).map((tag) ->
              span
                className: "label kbc-label-rounded-small label-default"
                key: tag
              ,
                tag
            ).toArray()
          else
            'N/A'
      ListGroupItem {key: 'query'},
        strong {className: "col-md-4"},
          'Query'
        span {className: "col-md-6"},
          if @props.value.get('query', '') != ''
            code null,
              @props.value.get('query')
          else
            'N/A'
      ListGroupItem {key: 'processed-tags'},
        strong {className: "col-md-4"},
          'Processed tags'
        span {className: "col-md-6"},
          if @props.value.get('processed_tags', Immutable.List()).count()
            @props.value.get('processed_tags', Immutable.List()).map((tag) ->
              span
                className: "label kbc-label-rounded-small label-default"
                key: tag
              ,
                tag
            ).toArray()
          else
            'N/A'
    ]
    ListGroup {className: "clearfix"}, _.reject(ListGroupItems, (obj) -> obj == undefined)
)

module.exports = FileInputMappingDetail
