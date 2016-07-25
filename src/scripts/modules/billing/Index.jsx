import React from 'react';
import {fromJS, List} from 'immutable';
import FileSize from '../../react/common/FileSize';

import ApplicationStore from '../../stores/ApplicationStore';

function daySum(components, propertyName) {
    return components
        .filter(function(component) {
            return component.has(propertyName);
        })
        .reduce(function(reduction, component) {
            return reduction + component.get(propertyName);
        }, 0);
}

const data = fromJS([
    {
        "date": "Jul 1",
        "components": [
            {
                "name": "Google Analytics",
                "containerOut": 2345,
                "containerIn": 234324,
                "storageIn": 43453,
                "storageOut": 0
            },
            {
                "name": "GoodData Writer",
                "containerOut": 2345,
                "containerIn": 234324,
                "storageIn": 0,
                "storageOut": 23424
            },
            {
                "name": "Transformation",
                "containerOut": 0,
                "containerIn": 0,
                "storageIn": 0,
                "storageOut": 23424
            },
            {
                "name": "Geneea",
                "containerOut": 12334,
                "containerIn": 12313,
                "storageIn": 234324,
                "storageOut": 23424,
                "appUsage": 234
            },
            {
                "name": "Storage Direct",
                "storageIn": 123,
                "storageOut": 23424
            }
        ]
    },
    {
        "date": "Jul 2",
        "components": [
            {
                "name": "Google Analytics",
                "containerOut": 2345,
                "containerIn": 234324,
                "storageIn": 43453,
                "storageOut": 0
            },
            {
                "name": "GoodData Writer",
                "containerOut": 2345,
                "containerIn": 234324,
                "storageIn": 0,
                "storageOut": 23424
            },
            {
                "name": "Transformation",
                "containerOut": 0,
                "containerIn": 0,
                "storageIn": 0,
                "storageOut": 23424
            },
            {
                "name": "Storage Direct",
                "storageIn": 123,
                "storageOut": 23424
            }
        ]
    }
]);

export default React.createClass({

    render() {
        return (
            <div className="container-fluid kbc-main-content">
                <ul className="nav nav-tabs">
                    <li role="presentation">
                        <a href={this.projectPageUrl('settings-users')}>Users</a>
                    </li>
                    <li role="presentation">
                        <a href={this.projectPageUrl('settings')}>Settings</a>
                    </li>
                    <li role="presentation">
                        <a href={this.projectPageUrl('settings-limits')}>Limits</a>
                    </li>
                    <li role="presentation" className="active">
                        <a href={this.projectPageUrl('settings-billing')}>Billing</a>
                    </li>
                </ul>
                <table className="table">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Data In</th>
                            <th>Data Out</th>
                            <th>Storage In</th>
                            <th>Storage Out</th>
                            <th>Application Credits</th>
                        </tr>
                    </thead>
                    <tbody>
                        {data.map(this.dayRow)}
                    </tbody>
                </table>
            </div>
        );
    },

    dayRow(day) {
        const header = (
          <tr>
              <td><strong>{day.get('date')}</strong></td>
              <td>
                  <strong>
                      <FileSize size={daySum(day.get('components'), 'containerIn')} />
                  </strong>
              </td>
              <td>
                  <strong>
                      <FileSize size={daySum(day.get('components'), 'containerOut')} />
                  </strong>
              </td>
              <td>
                  <strong>
                      <FileSize size={daySum(day.get('components'), 'storageIn')} />
                  </strong>
              </td>
              <td>
                  <strong>
                      <FileSize size={daySum(day.get('components'), 'storageOut')} />
                  </strong>
              </td>
              <td>
                  <strong>
                      {daySum(day.get('components'), 'appUsage')}
                  </strong>
              </td>
          </tr>
        );
        const components = day.get('components').map(this.componentRow);

        return List([header, components]);
    },

    componentRow(component) {
        return (
          <tr>
              <td><span style={{paddingLeft: '10px'}}>{component.get('name')}</span></td>
              <td>
                  <FileSize size={component.get('containerIn')}/>
              </td>
              <td>
                  <FileSize size={component.get('containerOut')}/>
              </td>
              <td>
                  <FileSize size={component.get('storageIn')}/>
              </td>
              <td>
                  <FileSize size={component.get('storageOut')}/>
              </td>
              <td>
                  {component.get('appUsage')}
              </td>
          </tr>
        );
    },


    projectPageUrl(path) {
        return ApplicationStore.getProjectPageUrl(path);
    }

});