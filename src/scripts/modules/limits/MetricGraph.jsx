import React, {PropTypes} from 'react';
import Keen from 'keen-js';


export default React.createClass({
  propTypes: {
    query: PropTypes.object.isRequired,
    limitValue: PropTypes.number,
    client: PropTypes.object.isRequired,
    isAlarm: PropTypes.bool.isRequired
  },

  componentDidMount() {
    var query = new Keen.Query('average', this.props.query);
    var chart = new Keen.Dataviz()
      .el(React.findDOMNode(this.refs.metric))
      .chartType('linechart')
      .chartOptions({
        isStacked: true,
        legend: { position: 'none' },
        backgroundColor: this.props.isAlarm ? '#f2dede' : '#fff'
      })
      .prepare();

    var limitValue = this.props.limitValue;

    this.props.client.run([query], function(err, res) {
      var result = res.result;
      var data = [];
      var i = 0;

      while (i < result.length) {
        if (limitValue) {
          data[i] = {
            timeframe: result[i].timeframe,
            value: [
              { category: 'Metric', result: result[i].value },
              { category: 'Limit', result: limitValue }
            ]
          };
        } else {
          data[i] = { // format the data so it can be charted
            timeframe: result[i].timeframe,
            value: result[i].value
          };
        }

        if (i === result.length - 1) { // chart the data
          chart
            .parseRawData({ result: data })
            .render();
        }
        i++;
      }
    });
  },

  render() {
    return (
      <div ref="metric"/>
    );
  }

});