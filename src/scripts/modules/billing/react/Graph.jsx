import React, {PropTypes}  from 'react';
import {fromJS} from 'immutable';

function format(unit) {
  switch (unit) {
    case 'millions':
      return '#,### M';
    case 'bytes':
      return '#,### GB';
    default:
      return '#,###';
  }
}

function getConversion(unit) {
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

function createChartOptions(options) {
  return fromJS({
    colors: [
      /* teal      red        yellow     purple     orange     mint       blue       green      lavender */
      '#0bbcfa', '#fb4f61', '#eeb058', '#8a8ad6', '#ff855c', '#00cfbb', '#5a9eed', '#73d483', '#c879bb',
      '#0099b6', '#d74d58', '#cb9141', '#6b6bb6', '#d86945', '#00aa99', '#4281c9', '#57b566', '#ac5c9e',
      '#27cceb', '#ff818b', '#f6bf71', '#9b9be1', '#ff9b79', '#26dfcd', '#73aff4', '#87e096', '#d88bcb'
    ],
    legend: {
      position: 'none'
    },
    hAxis: {
      gridlines: {
        color: 'none'
      },
      textStyle: {
        color: '#98a2b5'
      },
      format: 'd.M.'
    },
    vAxis: {
      gridlines: {
        count: 4,
        color: '#e8e8ef'
      },
      baseline: 0,
      baselineColor: '#CCC',
      minValue: 0,
      textPosition: 'in',
      textStyle: {
        color: '#98a2b5'
      },
      viewWindow: {
        min: 0
      },
      format: options.vAxisFormat
    },
    chartArea: {
      left: 10,
      top: 10,
      width: options.elementWidth - 20,
      height: (0.5 * options.elementWidth - 20) - 10
    },
    lineWidth: 3,
    areaOpacity: 0.1,
    seriesType: 'area',
    series: {
      1: {
        type: 'line',
        lineWidth: 1
      }
    }
  });
}

export default React.createClass({

  propTypes: {
    data: PropTypes.object.isRequired,
    showTrendLine: PropTypes.bool.isRequired,
    unit: PropTypes.string.isRequired
  },

  getDefaultProps() {
    return {
      data: fromJS([])
    };
  },

  componentDidUpdate: function() {
    this.drawGraph();
  },

  getGraphData() {
    if (!this.props.data.isEmpty()) {
      var conversion = getConversion(this.props.unit);
      var converted = [
        [
          'Date',
          'Value',
          {'type': 'string', 'role': 'style'}
        ]
      ];

      var index = 1;
      this.props.data.forEach(function(item) {
        converted.push([
          new Date(item.get('date')),
          conversion(item.get('value')),
          null
        ]);

        index += 1;
      });

      return converted;
    } else {
      return [];
    }
  },

  drawGraph() {
    const element = React.findDOMNode(this.refs.metric);
    const chartOptions = createChartOptions({
      elementWidth: element.offsetWidth,
      vAxisFormat: format(this.props.unit)
    });
    const graphData = this.getGraphData();

    /* global google */
    const ds = new google.visualization.arrayToDataTable(graphData);
    const combo = new google.visualization.ComboChart(element);
    combo.draw(ds, chartOptions.toJS());
  },

  render() {
    return (
      <div ref="metric"/>
    );
  }

});
