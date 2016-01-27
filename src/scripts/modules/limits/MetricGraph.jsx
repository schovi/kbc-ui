import React, {PropTypes} from 'react';
import Keen from 'keen-js';


export default React.createClass({
  propTypes: {
    query: PropTypes.object.isRequired,
    title: PropTypes.string.isRequired,
    client: PropTypes.object.isRequired
  },

  componentDidMount() {
    var query = new Keen.Query('average', this.props.query);
    this.props.client.draw(query, React.findDOMNode(this.refs.metric), {
      chartType: 'columnchart',
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