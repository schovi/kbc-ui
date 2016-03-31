import React from 'react';
import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import VersionsStore from '../../stores/VersionsStore';
import RoutesStore from '../../../../stores/RoutesStore';
import VersionRow from '../components/VersionRow';
import {Table} from 'react-bootstrap';
import SearchRow from '../../../../react/common/SearchRow';
import VersionsActionCreators from '../../VersionsActionCreators';
import fuzzy from 'fuzzy';
import ImmutableRenderMixin from '../../../../react/mixins/ImmutableRendererMixin';

export default React.createClass({
  mixins: [createStoreMixin(VersionsStore, RoutesStore), ImmutableRenderMixin],

  getStateFromStores() {
    var componentId, configId, versions, filteredVersions, query;
    if (RoutesStore.getCurrentRouteParam('bucketId')) {
      componentId = 'transformation';
      configId = RoutesStore.getCurrentRouteParam('bucketId');
    } else {
      componentId = RoutesStore.getCurrentRouteParam('componentId');
      configId = RoutesStore.getCurrentRouteParam('configId');
    }

    versions = VersionsStore.getVersions(componentId, configId);
    query = VersionsStore.getSearchFilter(componentId, configId);
    filteredVersions = versions;
    if (query && query !== '') {
      filteredVersions = versions.filter(function(version) {
        return (
          fuzzy.match(query, (String(version.get('version')) || '')) ||
          fuzzy.match(query, (version.get('changeDescription') || '')) ||
          fuzzy.match(query, (version.getIn(['creatorToken', 'description']) || '')) ||
          fuzzy.match(query, (String(version.get('created')) || ''))
        );
      });
    }

    return {
      componentId: componentId,
      configId: configId,
      versions: versions,
      filteredVersions: filteredVersions,
      newVersionNames: VersionsStore.getNewVersionNames(componentId, configId),
      query: VersionsStore.getSearchFilter(componentId, configId),
      isPending: VersionsStore.isPending(componentId, configId)
    };
  },

  renderVersionRows() {
    return this.state.filteredVersions.map(function(version, i) {
      return (
        <VersionRow
          key={version.get('version')}
          version={version}
          componentId={this.state.componentId}
          configId={this.state.configId}
          newVersionName={this.state.newVersionNames.get(version.get('version'))}
          isPending={this.state.isPending}
          hideRollback={(i === 0)}
        />
      );
    }, this).toArray();
  },

  onSearchChange(query) {
    VersionsActionCreators.changeFilter(this.state.componentId, this.state.configId, query);
  },

  render() {
    if (this.state.filteredVersions.count() === 0 && this.state.versions.count() > 0) {
      return (
        <div className="container-fluid kbc-main-content">
          <SearchRow className="row kbc-search-row" onChange={this.onSearchChange} query={this.state.query}/>
          <p className="row text-center">No results found.</p>
        </div>
      );
    }
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
