
import request from '../../../utils/request';


function createUrl(path) {
  let baseUrl = 'https://api.dropboxapi.com/1';
  return `${baseUrl}/${path}`;
}


function createRequest(method, path, token) {
  return request(method, createUrl(path))
    .set('Accept', 'application/json')
    .set('Authorization', `Bearer ${token}`);
}

export default {
  getCsvFilesFromDropbox(token) {
    return createRequest('POST', '/search/auto', token)
    .send('query=csv')
    .promise()
    .then((response) => {
      return response.body;
    });
  }
};