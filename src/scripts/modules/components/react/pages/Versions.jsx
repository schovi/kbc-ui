import React from 'react';
import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import VersionsStore from '../../stores/VersionsStore';
import RoutesStore from '../../../../stores/RoutesStore';
import VersionRow from '../components/VersionRow';
import {Table} from 'react-bootstrap';
import SearchRow from '../../../../react/common/SearchRow';
import VersionsActionCreators from '../../VersionsActionCreators';

export default React.createClass({
  mixins: [createStoreMixin(VersionsStore, RoutesStore)],

  getStateFromStores() {
    var componentId, configId;
    if (RoutesStore.getCurrentRouteParam('bucketId')) {
      componentId = 'transformation';
      configId = RoutesStore.getCurrentRouteParam('bucketId');
    } else {
      componentId = RoutesStore.getCurrentRouteParam('componentId');
      configId = RoutesStore.getCurrentRouteParam('configId');
    }
    return {
      componentId: componentId,
      configId: configId,
      versions: VersionsStore.getFilteredVersions(componentId, configId),
      newVersionNames: VersionsStore.getNewVersionNames(componentId, configId),
      query: VersionsStore.getSearchFilter(componentId, configId)
    };
  },

  renderVersionRows() {
    return this.state.versions.map(function(version) {
      return (
        <VersionRow
          key={version.get('version')}
          version={version}
          componentId={this.state.componentId}
          configId={this.state.configId}
          newVersionName={this.state.newVersionNames.get(version.get('version'))}
        />
      );
    }, this).toArray();
  },

  onSearchChange(query) {
    VersionsActionCreators.changeFilter(this.state.componentId, this.state.configId, query);
  },

  render() {
    return (
      <div className="container-fluid kbc-main-content">
        <SearchRow className="row kbc-search-row" onChange={this.onSearchChange} query={this.state.query}/>
        <Table striped hover>
          <thead>
            <tr>
              <th>#</th>
              <th>Description</th>
              <th>Changed</th>
              <th>Created by</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            {this.renderVersionRows()}
          </tbody>
        </Table>
      </div>
    );
  }

});
