import React, {PropTypes}  from 'react';
import GraphLegend from './GraphLegend';
import GraphVisualization from './GraphVisualization';

export function getConversion(unit) {
  switch (unit) {
    case 'millions':
      return function(val) {
        return Number((val / (1000 * 1000)).toFixed(2));
      };
    case 'bytes':
      return function(val) {
        return Number((val / (1000 * 1000 * 1000)).toFixed(2));
      };
    default:
      return function(val) {
        return val;
      };
  }
}

export default React.createClass({

  propTypes: {
    data: PropTypes.object.isRequired,
    unit: PropTypes.string.isRequired
  },

  render() {
    return (
      <div>
        <GraphVisualization data={this.props.data}/>
        <GraphLegend
          title="Storage IO"
          value={this.props.data.reduce(function(monthSummary, day) {
            return monthSummary + day.get('value');
          }, 0)}
        />
      </div>
    );
  }

});
