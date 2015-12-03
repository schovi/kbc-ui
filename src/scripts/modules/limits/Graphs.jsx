import React, {PropTypes} from 'react';
import StorageApi from '../components/StorageApi';
import Keen from 'keen-js';

import Metric from './Metric';

export default React.createClass({
  propTypes: {
    projectId: PropTypes.number.isRequired
  },

  getInitialState() {
    return {
      client: null,
      isKeenReady: false
    };
  },

  componentDidMount() {
    StorageApi
      .getKeenCredentials()
      .then((response) => {
        const client = new Keen({
          readKey: response.keenToken,
          projectId: '5571e4d559949a32ff02043e'
        });
        this.setState({
          client: client
        });
        Keen.ready(this.keenReady);
      });
  },

  render() {
    if (!this.state.isKeenReady) {
      return (
        <div className="text-muted">Loading ...</div>
      );
    }
    return (
      <div>
        {this.getMetrics().map((settings) => {
          return React.createElement(Metric, {
            title: settings.title,
            query: settings.query,
            client: this.state.client
          });
        })}
      </div>
    );
  },

  keenReady() {
    this.setState({
      isKeenReady: true
    });
  },

  getMetrics() {
    return [
      {
        title: 'storage.dataSizeBytes',
        eventCollection: 'sapi-project-snapshots',
        targetProperty: 'dataSizeBytes'
      },
      {
        title: 'storage.rowsCount',
        eventCollection: 'sapi-project-snapshots',
        targetProperty: 'rowsCount'
      }
    ].map((metric) => {
      return {
        title: metric.title,
        query: {
          eventCollection: metric.eventCollection,
          targetProperty: metric.targetProperty,
          timeframe: 'this_14_days',
          interval: 'daily',
          filters: [
            {
              property_name: 'kbc.project.id',
              operator: 'eq',
              property_value: this.props.projectId
            }
          ]
        }
      };
    });
  }

});