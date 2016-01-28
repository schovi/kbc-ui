import React, {PropTypes} from 'react';
import Keen from 'keen-js';


export default React.createClass({
  propTypes: {
    query: PropTypes.object.isRequired,
    client: PropTypes.object.isRequired,
    isAlarm: PropTypes.bool.isRequired
  },

  componentDidMount() {
    var query = new Keen.Query('average', this.props.query);
    this.props.client.draw(query, React.findDOMNode(this.refs.metric), {
      chartType: 'areachart',
      title: ' ',
      chartOptions: {
        isStacked: true,
        backgroundColor: this.props.isAlarm ? '#f2dede' : '#fff'
      }
    });
  },

  render() {
    return (
      <div ref="metric"/>
    );
  }

});