import {fromJS} from 'immutable';
import {webalize} from '../../utils/string';

export default function (configName, baseConfig) {
  const template = fromJS({
    'parameters': {
      'api': {
        'baseUrl': 'https://api.adform.com/Services/',
        'pagination': {
          'method': 'response.url'
        },
        'authentication': {
          type: 'login',
          loginRequest: {
            endpoint: 'Security/Login',
            headers: {
              'Content-Type': 'application/json'
            },
            method: 'POST',
            params: {
              UserName: {
                attr: 'username'
              },
              PassWord: {
                attr: '#password'
              }
            }
          },
          apiRequest: {
            headers: {
              Ticket: 'Ticket'
            }
          }
        },
        'name': 'adform'
      },
      'config': {
        'username': '',
        '#password': ''
      }
    }
  });

  return template
    .setIn(['parameters', 'config', 'id'], webalize(configName))
    .mergeDeep(baseConfig);
}

