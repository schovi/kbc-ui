import React from 'react';
import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import VersionsStore from '../../stores/VersionsStore';
import RoutesStore from '../../../../stores/RoutesStore';
import VersionRow from '../components/VersionRow';
import {getPreviousVersion} from '../../../../utils/VersionsDiffUtils';
import {Table} from 'react-bootstrap';
import SearchRow from '../../../../react/common/SearchRow';
import VersionsActionCreators from '../../VersionsActionCreators';
import fuzzy from 'fuzzy';
import ImmutableRenderMixin from '../../../../react/mixins/ImmutableRendererMixin';

export default function(componentId, configIdParam = 'config') {
  return React.createClass({
    mixins: [createStoreMixin(VersionsStore, RoutesStore), ImmutableRenderMixin],

    getStateFromStores() {
      var versions, filteredVersions, query;
      const configId = RoutesStore.getCurrentRouteParam(configIdParam);
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
        isPending: VersionsStore.isPendingConfig(componentId, configId),
        pendingActions: VersionsStore.getPendingVersions(componentId, configId)
      };
    },

    renderVersionRows() {
      return this.state.filteredVersions.map(function(version, i) {
        const previousVersion = getPreviousVersion(this.state.versions, version);
        return (
          <VersionRow
            key={version.get('version')}
            version={version}
            componentId={this.state.componentId}
            configId={this.state.configId}
            newVersionName={this.state.newVersionNames.get(version.get('version'))}
            isCopyPending={this.state.pendingActions.getIn([version.get('version'), 'copy'], false)}
            isCopyDisabled={this.state.isPending}
            isRollbackPending={this.state.pendingActions.getIn([version.get('version'), 'rollback'], false)}
            isRollbackDisabled={this.state.isPending}
            hideRollback={(i === 0)}
            isDiffPending={this.state.pendingActions.getIn([version.get('version'), 'config'])}
            isDiffDisabled={this.state.isPending}
            previousVersion={previousVersion}
            onPrepareVersionsDiffData= {() => this.prepareVersionsDiffData(version, previousVersion)}
          />
        );
      }, this).toArray();
    },


    prepareVersionsDiffData(version1, version2) {
      const configId = this.state.configId;
      return VersionsActionCreators.loadTwoComponentConfigVersions(
        this.state.componentId, configId, version1.get('version'), version2.get('version'));
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
}
