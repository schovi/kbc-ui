import request from '../../utils/request';
import ComponentStore from './stores/ComponentsStore';
function createUrl() {
  let baseUrl = ComponentStore.getComponent('keboola.ssh-keygen').get('uri');
  return `${baseUrl}`;
}

function createRequest(method) {
  return request(method, createUrl());
}

export default {
  generateKeys() {
    return createRequest('POST')
    .promise()
    .then((response) => {
      return response.body;
    });
  }
};
