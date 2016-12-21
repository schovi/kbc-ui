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
import {Map} from 'immutable';

function simpleMatch(query, test) {
  return test.toLocaleLowerCase().indexOf(query.toLowerCase()) >= 0;
}

const ITEMS_PER_PAGE = 20;

export default function(componentIdValue, configIdParam = 'config') {
  return React.createClass({
    mixins: [createStoreMixin(VersionsStore, RoutesStore), ImmutableRenderMixin],

    getStateFromStores() {
      var versions, filteredVersions, query;
      const configId = RoutesStore.getCurrentRouteParam(configIdParam);
      const componentId = RoutesStore.getCurrentRouteParam('component') || componentIdValue;
      versions = VersionsStore.getVersions(componentId, configId);
      query = VersionsStore.getSearchFilter(componentId, configId);
      filteredVersions = versions;
      if (query && query !== '') {
        filteredVersions = versions.filter(function(version) {
          return (
            simpleMatch(query, (String(version.get('version')) || '')) ||
            fuzzy.test(query, (version.get('changeDescription') || '')) ||
            simpleMatch(query, (version.getIn(['creatorToken', 'description']) || '')) ||
            simpleMatch(query, (String(version.get('created')) || ''))
          );
        });
      }
      return {
        componentId: componentId,
        configId: configId,
        versions: versions,
        versionsConfigs: VersionsStore.getVersionsConfigs(componentId, configId),
        filteredVersions: filteredVersions,
        newVersionNames: VersionsStore.getNewVersionNames(componentId, configId),
        query: VersionsStore.getSearchFilter(componentId, configId),
        isPending: VersionsStore.isPendingConfig(componentId, configId),
        pendingActions: VersionsStore.getPendingVersions(componentId, configId),
        pendingMultiLoad: VersionsStore.getPendingMultiLoad(componentId, configId)
      };
    },

    getInitialState() {
      return {
        page: 1
      };
    },

    getPaginatedVersions() {
      return this.state.filteredVersions.slice(0, ITEMS_PER_PAGE * this.state.page);
    },

    renderVersionRows() {
      const allVersions = this.state.versions;
      return this.getPaginatedVersions().map(function(version, i) {
        const previousVersion = getPreviousVersion(this.state.versions, version);
        const previousVersionConfig = getPreviousVersion(this.state.versionsConfigs, version) || Map();
        const currentVersionConfig = this.state.versionsConfigs.filter((currentVersion) => {
          return version.get('version') === currentVersion.get('version');
        }).first() || Map();
        const isMultiPending = this.state.pendingMultiLoad.get(version.get('version'), false);
        return (
          <VersionRow
            key={version.get('version')}
            version={version}
            versionConfig={currentVersionConfig}
            componentId={this.state.componentId}
            configId={this.state.configId}
            newVersionName={this.state.newVersionNames.get(version.get('version'))}
            isCopyPending={this.state.pendingActions.getIn([version.get('version'), 'copy'], false)}
            isCopyDisabled={this.state.isPending}
            isRollbackPending={this.state.pendingActions.getIn([version.get('version'), 'rollback'], false)}
            isRollbackDisabled={this.state.isPending}
            hideRollback={(i === 0)}
            isDiffPending={isMultiPending}
            isDiffDisabled={this.state.isPending || isMultiPending}
            previousVersion={previousVersion}
            previousVersionConfig={previousVersionConfig}
            onPrepareVersionsDiffData= {() => this.prepareVersionsDiffData(version, previousVersion)}
            isLast={allVersions.first().get('version') === version.get('version')}
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

    onShowMore() {
      const nextPage = this.state.page + 1;
      this.setState({page: nextPage});
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
                <th />
                <th>Description</th>
                <th>Changed</th>
                <th>Created by</th>
                <th />
              </tr>
            </thead>
            <tbody>
              {this.renderVersionRows()}
            </tbody>
          </Table>
          {this.state.filteredVersions.count() > this.state.page * ITEMS_PER_PAGE ?
           <div className="kbc-block-with-padding">
             <button onClick={this.onShowMore} className="btn btn-default btn-large text-center">
               More..
             </button>
           </div>
           : null
          }
        </div>
      );
    }
  });
}
