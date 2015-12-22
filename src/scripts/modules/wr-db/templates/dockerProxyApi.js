const dockerComponents = ['wr-db-mssql'];
import {List, Map, fromJS} from 'immutable';
import Promise from 'bluebird';

import InstalledComponentsActions from '../../components/InstalledComponentsActionCreators';
import InstalledComponentsStore from '../../components/stores/InstalledComponentsStore';

function isDockerBasedWriter(componentId) {
  return dockerComponents.includes(componentId);
}
const tablesPath = ['storage', 'input', 'tables'];

function updateTablesMapping(data, table) {
  const tableId = table.get('id');
  const columns = table.get('items')
        .filter((c) => c.get('type') !== 'IGNORE')
        .map( (c) => c.get('name'));
  var mappingTable = fromJS({
    source: tableId,
    destination: tableId
  });
  mappingTable = mappingTable.set('columns', columns);
  var tables = data.getIn(tablesPath, List());
  var found = false;
  tables = tables.map( (t) => {
    if (t.get('source') === tableId) {
      found = true;
      return mappingTable;
    } else {
      return t;
    }
  });
  if (!found) {
    tables = tables.push(table);
  }
  return data.setIn(tablesPath, tables);
}

export default function(componentId) {
  if (!isDockerBasedWriter(componentId)) {
    return null;
  }

  return {
    loadConfigData(configId) {
      return InstalledComponentsActions.loadComponentConfigData(componentId, configId).then(
        () => InstalledComponentsStore.getConfigData(componentId, configId) || Map()
      );
    },

    saveConfigData(configId, data) {
      return InstalledComponentsActions.saveComponentConfigData(componentId, configId, data);
    },

    postTable(configId, tableId, table) {
      const tableToSave = fromJS({
        dbName: table.dbName,
        export: table.export,
        tableId: tableId,
        items: []
      });

      return this.loadConfigData(configId).then(
        (data) => {
          var dataToSave = data;
          var tables = data.getIn(['parameters', 'tables'], List());
          dataToSave = data.setIn(['parameters', 'tables'], tables.push(tableToSave));
          dataToSave = updateTablesMapping(dataToSave, tableToSave);
          return this.saveConfigData(configId, dataToSave);
        }
      );
    },

    getCredentials(configId) {
      return this.loadConfigData(configId).then(
        (data) => {
          return data.getIn(['parameters', 'db']);
        }
      );
    },

    getTables(configId) {
      return this.loadConfigData(configId).then(
        (data) => {
          const tables = data.getIn(['parameters', 'tables']);
          return tables.map((table) => {
            return table
              .set('id', table.get('tableId'))
              .set('name', table.get('dbName'));
          });
        }
      );
    },

    getTable(configId, tableId) {
      return this.loadConfigData(configId).then(
        (data) => {
          const tables = data.getIn(['parameters', 'tables']);
          var table = tables.find( (t) => t.get('tableId') === tableId);
          if (!table) {
            return Promise.reject('Error: table ' + tableId + ' not exits in the config');
          }

          table = table.set('columns', table.get('items'));
          return table;
        }
      );
    }

  };
}
