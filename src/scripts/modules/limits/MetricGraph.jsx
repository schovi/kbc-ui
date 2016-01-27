import React, {PropTypes} from 'react';
import Keen from 'keen-js';


export default React.createClass({
  propTypes: {
    query: PropTypes.object.isRequired,
    client: PropTypes.object.isRequired
  },

  componentDidMount() {
    var query = new Keen.Query('average', this.props.query);
    this.props.client.draw(query, React.findDOMNode(this.refs.metric), {
      chartType: 'areachart',
      title: ' ',
      chartOptions: {
        isStacked: true
      }
    });
  },

  render() {
    return (
      <div ref="metric"/>
    );
  }

});