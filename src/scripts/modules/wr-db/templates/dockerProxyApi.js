const dockerComponents = [
  'wr-db-mssql',
  'keboola.wr-db-mssql-v2',
  'keboola.wr-redshift-v2',
  'keboola.wr-db-mysql',
  'keboola.wr-db-impala',
  'keboola.wr-db-oracle',
  'keboola.wr-db-snowflake'
];
import {List, Map, fromJS} from 'immutable';
import Promise from 'bluebird';

import InstalledComponentsActions from '../../components/InstalledComponentsActionCreators';
import InstalledComponentsStore from '../../components/stores/InstalledComponentsStore';

function isDockerBasedWriter(componentId) {
  return dockerComponents.indexOf(componentId) >= 0;
}
const tablesPath = ['storage', 'input', 'tables'];

function updateTablesMapping(data, table) {
  const tableId = table.get('tableId');
  const columns = table.get('items')
        .filter((c) => c.get('type') !== 'IGNORE')
        .map( (c) => c.get('name'));
  var mappingTable = fromJS({
    source: tableId,
    destination: tableId + '.csv'
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
    tables = tables.push(mappingTable);
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

    saveConfigData(configId, data, diffMessage) {
      return InstalledComponentsActions.saveComponentConfigData(componentId, configId, data, diffMessage);
    },

    // ######### GET SINGLE TABLE UPLOAD RUN PARAMS
    getTableRunParams(configId, tableId) {
      const data = InstalledComponentsStore.getConfigData(componentId, configId);
      const tables = data.getIn(['parameters', 'tables']).filter((t) => t.get('tableId') === tableId);
      const mapping = data.getIn(tablesPath).filter((t) => t.get('source') === tableId);
      const runParams = {
        config: configId,
        configData: data
          .setIn(['parameters', 'tables'], tables)
          .setIn(tablesPath, mapping)
          .toJS()
      };
      return runParams;
    },

    // ######### GET RUN PARAMS
    getRunParams(configId) {
      return {
        config: configId
      };
    },

    setTableV2(configId, tableId, tableData) {
      return this.loadConfigData(configId).then(
        (data) => {
          const tables = data.getIn(['parameters', 'tables'], List())
                .map((t) => {
                  if (t.get('tableId') === tableId) {
                    return tableData;
                  } else {
                    return t;
                  }
                }, tableData);
          var dataToSave = data.setIn(['parameters', 'tables'], tables);
          const msg = `Update parameters of ${tableId}`;
          return this.saveConfigData(configId, dataToSave, msg);
        }
      );
    },
    // ########## SET TABLE
    setTable(configId, tableId, tableData) {
      return this.loadConfigData(configId).then(
        (data) => {
          const tables = data.getIn(['parameters', 'tables'], List())
                .map((t) => {
                  if (t.get('tableId') === tableId) {
                    return t
                      .set('export', !!tableData.export)
                      .set('dbName', tableData.dbName);
                  } else {
                    return t;
                  }
                }, tableData);
          var dataToSave = data.setIn(['parameters', 'tables'], tables);
          const msg = `Update parameters of ${tableId}`;
          return this.saveConfigData(configId, dataToSave, msg);
        }
      );
    },

    // ########## SET TABLE COLUMNS
    setTableColumns(configId, tableId, columns) {
      const columnsToSave = columns.map( (c) => {
        return {
          name: c.name,
          dbName: c.dbName,
          type: c.type,
          size: c.size,
          nullable: c.null === '1',
          default: c.default
        };
      });
      return this.loadConfigData(configId).then(
        (data) => {
          var newTable = null;
          const tables = data.getIn(['parameters', 'tables'], List())
                .map((t) => {
                  if (t.get('tableId') === tableId) {
                    newTable = t.set('items', fromJS(columnsToSave).filter((c) => c.get('type') !== 'IGNORE'));
                    return newTable;
                  } else {
                    return t;
                  }
                }, newTable);
          var dataToSave = data.setIn(['parameters', 'tables'], tables);
          dataToSave = updateTablesMapping(dataToSave, newTable);
          const msg = `Update columns of ${tableId}`;
          return this.saveConfigData(configId, dataToSave, msg);
        }
      );
    },

    // ######### DELETE TABLE
    deleteTable(configId, tableId) {
      return this.loadConfigData(configId).then(
        (data) => {
          const paramTables = data.getIn(['parameters', 'tables']).filter((t) => t.get('tableId') !== tableId);
          const mappingTables = data.getIn(tablesPath, List()).filter((t) => t.get('source') !== tableId);
          const dataToSave = data
                .setIn(['parameters', 'tables'], paramTables)
                .setIn(tablesPath, mappingTables);
          const msg = `Remove ${tableId}`;
          return this.saveConfigData(configId, dataToSave, msg);
        }
      );
    },

    // ######## POST TABLE
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
          const msg = `Add table ${tableId}`;
          return this.saveConfigData(configId, dataToSave, msg);
        }
      );
    },

    // POST CREDENTIALS
    postCredentials(configId, credentials) {
      return this.loadConfigData(configId).then(
        (data) => {
          const dataToSave = data.setIn(['parameters', 'db'], fromJS(credentials));
          const msg = 'Update credentials';
          return this.saveConfigData(configId, dataToSave, msg);
        }
      );
    },

    // ########### GET CREDENTIALS
    getCredentials(configId) {
      return this.loadConfigData(configId).then(
        (data) => {
          return data.getIn(['parameters', 'db'], Map());
        }
      );
    },

    // ############# GET TABLES
    getTables(configId) {
      return this.loadConfigData(configId).then(
        (data) => {
          const tables = data.getIn(['parameters', 'tables'], List());
          return tables.map((table) => {
            return table
              .set('id', table.get('tableId'))
              .set('name', table.get('dbName'));
          });
        }
      );
    },

    // ############ GET TABLE
    getTable(configId, tableId) {
      return this.loadConfigData(configId).then(
        (data) => {
          const tables = data.getIn(['parameters', 'tables'], List());
          var table = tables.find( (t) => t.get('tableId') === tableId);
          if (!table) {
            return Promise.reject('Error: table ' + tableId + ' not exits in the config');
          }
          const columns = table.get('items', List()).map((c) => {
            return c.set('null', c.get('nullable', false) ? '1' : '0');
          });
          table = table.set('columns', columns);
          return table;
        }
      );
    }

  };
}
