import React from 'react';
import ApplicationStore from '../../stores/ApplicationStore';
import createStoreMixin from '../../react/mixins/createStoreMixin';
import LimitRow from './LimitRow';
import StorageApi from '../components/StorageApi';
import Keen from 'keen-js';

import {TabbedArea, TabPane} from 'react-bootstrap';
import {fromJS} from 'immutable';

const LIMITS_METADATA = fromJS({
  'goodData.prodTokenEnabled': {
    name: 'Production project enabled'
  },
  'goodData.dataSizeBytes': {
    name: 'Project size'
  },
  'goodData.usersCount': {
    name: 'Users count'
  },
  'kbc.adminsCount': {
    name: 'Administrators count'
  },
  'storage.dataSizeBytes': {
    name: 'Storage size'
  },
  'storage.rowsCount': {
    name: 'Storage rows count'
  },
  'orchestrations.count': {
    name: 'Orchestrations count'
  }
});

function prepareConnectionData(limits, metrics, limitsMetadata) {
  let rows = [
    {
      id: 'storage.dataSizeBytes',
      limitValue: limits.getIn(['storage.dataSizeBytes', 'value']),
      metricValue: metrics.getIn(['storage.dataSizeBytes', 'value']),
      name: limitsMetadata.getIn(['storage.dataSizeBytes', 'name']),
      unit: 'bytes',
      graph: {
        eventCollection: 'sapi-project-snapshots',
        targetProperty: 'dataSizeBytes'
      }
    },
    {
      id: 'storage.rowsCount',
      limitValue: limits.getIn(['storage.rowsCount', 'value']),
      metricValue: metrics.getIn(['storage.rowsCount', 'value']),
      name: limitsMetadata.getIn(['storage.rowsCount', 'name']),
      graph: {
        eventCollection: 'sapi-project-snapshots',
        targetProperty: 'rowsCount'
      }
    },
    {
      id: 'kbc.adminsCount',
      limitValue: limits.getIn(['kbc.adminsCount', 'value']),
      metricValue: metrics.getIn(['kbc.adminsCount', 'value']),
      name: limitsMetadata.getIn(['kbc.adminsCount', 'name'])
    },
    {
      id: 'orchestrations.count',
      limitValue: limits.getIn(['orchestrations.count', 'value']),
      metricValue: metrics.getIn(['orchestrations.count', 'value']),
      name: limitsMetadata.getIn(['orchestrations.count', 'name'])
    }
  ];

  return fromJS(rows).map((row) => {
    return row.set('isAlarm', row.get('limitValue') && row.get('metricValue') && row.get('metricValue') > row.get('limitValue'));
  });
}

function prepareGoodDataData(limits, metrics, limitsMetadata) {
  let rows = [
    {
      id: 'goodData.dataSizeBytes',
      limitValue: limits.getIn(['goodData.dataSizeBytes', 'value']),
      metricValue: metrics.getIn(['goodData.dataSizeBytes', 'value']),
      name: limitsMetadata.getIn(['goodData.dataSizeBytes', 'name']),
      unit: 'bytes',
      graph: {
        eventCollection: 'gooddata-metrics',
        targetProperty: 'dataSizeBytes'
      }
    },
    {
      id: 'goodData.usersCount',
      limitValue: limits.getIn(['goodData.usersCount', 'value']),
      metricValue: metrics.getIn(['goodData.usersCount', 'value']),
      name: limitsMetadata.getIn(['goodData.usersCount', 'name']),
      graph: {
        eventCollection: 'gooddata-metrics',
        targetProperty: 'usersCount'
      }
    },
    {
      id: 'goodData.prodTokenEnabled',
      limitValue: limits.getIn(['goodData.prodTokenEnabled', 'value']),
      metricValue: metrics.getIn(['goodData.prodTokenEnabled', 'value']),
      name: limitsMetadata.getIn(['goodData.prodTokenEnabled', 'name']),
      unit: 'flag'
    }
  ];

  return fromJS(rows).map((row) => {
    return row.set('isAlarm', row.get('limitValue') && row.get('metricValue') && row.get('metricValue') > row.get('limitValue'));
  });
}

export default React.createClass({
  mixins: [createStoreMixin(ApplicationStore)],

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

  getStateFromStores() {
    return {
      sections: fromJS([
        {
          id: 'connection',
          icon: 'https://d3iz2gfan5zufq.cloudfront.net/images/cloud-services/rcp-data-type-assistant-32-1.png',
          title: 'Keboola Connection',
          limits: prepareConnectionData(
            ApplicationStore.getSapiToken().getIn(['owner', 'limits']),
            ApplicationStore.getSapiToken().getIn(['owner', 'metrics']),
            LIMITS_METADATA
          )
        },
        {
          id: 'goodData',
          icon: 'https://d3iz2gfan5zufq.cloudfront.net/images/cloud-services/gooddata32-2.png',
          title: 'GoodData',
          limits: prepareGoodDataData(
            ApplicationStore.getSapiToken().getIn(['owner', 'limits']),
            ApplicationStore.getSapiToken().getIn(['owner', 'metrics']),
            LIMITS_METADATA
          )
        }
      ])
    };
  },

  render() {
    return (
      <div className="container-fluid kbc-main-content">
        <TabbedArea activeKey="limits">
          <TabPane eventKey="settings" tab="Settings"/>
          <TabPane eventKey="limits" tab="Limits">
            {this.state.sections.map(this.section)}
          </TabPane>
          <TabPane eventKey="admins" tab="Users"/>
        </TabbedArea>

      </div>
    );
  },

  section(section) {
    return (
      <div>
        <div className="kbc-header">
          <div className="kbc-title">
            <h2>
               <span className="kb-sapi-component-icon">
                <img src={section.get('icon')} />
              </span>
              {section.get('title')}
            </h2>
          </div>
        </div>
        <div className="table">
          <div className="tbody">
            {section.get('limits').map(this.tableRow)}
          </div>
        </div>
      </div>
    );
  },

  tableRow(limit) {
    return React.createElement(LimitRow, {
      limit: limit,
      isKeenReady: this.state.isKeenReady,
      keenClient: this.state.client,
      key: limit.get('id')
    });
  },

  keenReady() {
    this.setState({
      isKeenReady: true
    });
  }

});