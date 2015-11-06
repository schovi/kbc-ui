import React, {PropTypes} from 'react';
import Keen from 'keen-js';


export default React.createClass({
  propTypes: {
    projectId: PropTypes.number.isRequired
  },

  componentDidMount() {
    this.client = new Keen({
      projectId: '',
      readKey: ''

    });
    Keen.ready(this.onKeenReady);
  },

  onKeenReady() {
    console.log('props', this.props);
    /* eslint camelcase: [0] */
    var query = new Keen.Query('average', {
      eventCollection: 'sapi-project-snapshots',
      filters: [{operator: 'eq', property_name: 'snapshot.project.id', property_value: this.props.projectId}],
      targetProperty: 'snapshot.dataSizeBytes',
      timeframe: 'this_7_days',
      timezone: 'UTC',
      interval: 'daily'
    });
    this.client.draw(query, React.findDOMNode(this.refs.container), {
      title: 'Storage Size'
    });
  },

  render() {
    return (
      <div ref="container">loading ...</div>
    );
  }
});