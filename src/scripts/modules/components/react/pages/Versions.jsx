import React from 'react';
import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import VersionsStore from '../../stores/VersionsStore';
import RoutesStore from '../../../../stores/RoutesStore';
import VersionRow from '../components/VersionRow';
import {Table} from 'react-bootstrap';

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
      versions: VersionsStore.getVersions(componentId, configId),
      newVersionNames: VersionsStore.getNewVersionNames(componentId, configId)
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

  render() {
    return (
      <div className="container-fluid kbc-main-content">
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
