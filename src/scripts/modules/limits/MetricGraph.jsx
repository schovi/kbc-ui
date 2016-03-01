import React, {PropTypes} from 'react';
import Keen from 'keen-js';


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
        return val / (1000 * 1000);
      };
    case 'bytes':
      return function(val) {
        return val / (1000 * 1000 * 1000);
      };
    default:
      return function(val) {
        return val;
      };
  }
}

export default React.createClass({
  propTypes: {
    query: PropTypes.object.isRequired,
    limitValue: PropTypes.number,
    unit: PropTypes.string,
    client: PropTypes.object.isRequired,
    isAlarm: PropTypes.bool.isRequired
  },

  componentDidMount() {
    var el = React.findDOMNode(this.refs.metric);
    var query = new Keen.Query('average', this.props.query);

    var chartOptions = {
      colors: [
        /* teal      red        yellow     purple     orange     mint       blue       green      lavender */
        '#00bbde', '#fe6672', '#eeb058', '#8a8ad6', '#ff855c', '#00cfbb', '#5a9eed', '#73d483', '#c879bb',
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
        format: format(this.props.unit),
        textPosition: 'in',
        textStyle: {
          color: '#98a2b5'
        }
      },
      chartArea: {
        left: 10,
        top: 0,
        width: el.offsetWidth - 20,
        height: 0.5 * el.offsetWidth - 20
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
    };
    var chart = new Keen.Dataviz()
      .chartType('areachart')
      .width(el.offsetWidth)
      .height(0.5 * el.offsetWidth)
      .el(el)
      .chartOptions(chartOptions)
      .prepare();

    var limitValue = this.props.limitValue,
      conversion = getConversion(this.props.unit);

    this.props.client.run([query], function() {
      chart
        .parseRequest(this)
        .call(function() {
          var converted = this.data().map(function(row, i, data) {
            const style = (i === data.length - 1) ? 'point {visible: true; size: 5;}' : null;
            if (i === 0) {
              if (limitValue) {
                return [
                  'Date',
                  'Value',
                  {'type': 'string', 'role': 'style'},
                  'Limit'
                ];
              } else {
                return [
                  'Date',
                  'Value',
                  {'type': 'string', 'role': 'style'}
                ];
              }
            } else {
              if (limitValue) {
                return [
                  row[0],
                  conversion(row[1]),
                  style,
                  conversion(limitValue)
                ];
              } else {
                return [
                  row[0],
                  conversion(row[1]),
                  style
                ];
              }
            }
          });
          /* global google */
          var ds = new google.visualization.arrayToDataTable(converted);
          var combo = new google.visualization.ComboChart(this.el());
          combo.draw(ds, chartOptions);
        });
    });
  },

  render() {
    return (
      <div ref="metric"/>
    );
  }

});