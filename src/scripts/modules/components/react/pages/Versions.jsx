import React from 'react';
import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import VersionsStore from '../../stores/VersionsStore';
import RoutesStore from '../../../../stores/RoutesStore';
import VersionRow from '../components/VersionRow';

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
        <div className="table table-hover">
          <div className="tbody">
            {this.renderVersionRows()}
          </div>
        </div>
      </div>
    );
  }

});
