import request from '../../utils/request';
import ApplicationStore from '../../stores/ApplicationStore';
import ComponentsStore from '../components/stores/ComponentsStore';

function createUrl(path) {
  const baseUrl = ComponentsStore.getComponent('queue').get('uri');
  return baseUrl + '/' + path;
}

function createRequest(method, path) {
  return request(method, createUrl(path))
    .set('X-StorageApi-Token', ApplicationStore.getSapiTokenString());
}

export default {
  getProjectMetrics(dateFrom, dateTo, period) {
    return createRequest('GET', 'metrics')
      .query({
        dateFrom: dateFrom,
        dateTo: dateTo,
        period: period
      })
      .promise()
      .then((response) => {
        return response.body;
      });
  }
};
