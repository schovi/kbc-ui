
import {fromJS} from 'immutable';

const LIMITS_METADATA = fromJS({
  'goodData.prodTokenEnabled': {
    name: 'Production project'
  },
  'goodData.dataSizeBytes': {
    name: 'Project size'
  },
  'goodData.usersCount': {
    name: 'Users count'
  },
  'kbc.adminsCount': {
    name: 'Users count'
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
      metricValue: metrics.getIn(['storage.dataSizeBytes', 'value'], 0),
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
      metricValue: metrics.getIn(['storage.rowsCount', 'value'], 0),
      name: limitsMetadata.getIn(['storage.rowsCount', 'name']),
      unit: 'millions',
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
      metricValue: metrics.getIn(['goodData.dataSizeBytes', 'value'], 0),
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
      metricValue: metrics.getIn(['goodData.usersCount', 'value'], 0),
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

export default function(limits, metrics) {
  return fromJS([
    {
      id: 'connection',
      icon: 'https://d3iz2gfan5zufq.cloudfront.net/images/cloud-services/rcp-data-type-assistant-32-1.png',
      title: 'Keboola Connection',
      limits: prepareConnectionData(
        limits,
        metrics,
        LIMITS_METADATA
      )
    },
    {
      id: 'goodData',
      icon: 'https://d3iz2gfan5zufq.cloudfront.net/images/cloud-services/gooddata32-2.png',
      title: 'GoodData',
      limits: prepareGoodDataData(
        limits,
        metrics,
        LIMITS_METADATA
      )
    }
  ]);
}