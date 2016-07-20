import React from 'react';
import {DropdownButton, MenuItem} from 'react-bootstrap';
import RollbackVersionMenuItem from './RollbackVersionMenuItem';
import CopyVersionMenuItem from './CopyVersionMenuItem';
import DiffMenuItem from './DiffMenuItem';
import createStoreMixin from '../mixins/createStoreMixin';
import InstalledComponentStore from '../../modules/components/stores/InstalledComponentsStore';
import VersionsStore from '../../modules/components/stores/VersionsStore';
import moment from 'moment';
import createVersionOnRollback from '../../utils/createVersionOnRollback';
import createVersionOnCopy from '../../utils/createVersionOnCopy';
import {getPreviousVersion} from '../../utils/VersionsDiffUtils';
import VersionsActionCreators from '../../../scripts/modules/components/VersionsActionCreators';
// import {Loader} from 'kbc-react-components';
import RoutesStore from '../../stores/RoutesStore';

export default React.createClass({
  mixins: [createStoreMixin(VersionsStore, InstalledComponentStore)],

  propTypes: {
    componentId: React.PropTypes.string.isRequired,
    configIdParam: React.PropTypes.string,
    dropDownButtonSize: React.PropTypes.string,
    firstVersionAsTitle: React.PropTypes.bool,
    allVersionsRouteName: React.PropTypes.string
  },

  getDefaultProps() {
    return {
      firstVersionAsTitle: true,
      dropDownButtonSize: 'small',
      configIdParam: 'config',
      allVersionsRouteName: null

    };
  },

  getStateFromStores() {
    const router = RoutesStore.getRouter();
    const configId = RoutesStore.getCurrentRouteParam(this.props.configIdParam);
    const componentId = this.props.componentId || RoutesStore.getCurrentRouteParam('component');
    return {
      versions: VersionsStore.getVersions(componentId, configId),
      newVersionNames: VersionsStore.getNewVersionNames(componentId, configId),
      isPending: VersionsStore.isPendingConfig(componentId, configId),
      pendingActions: VersionsStore.getPendingVersions(componentId, configId),
      router: router,
      configId: configId,
      componentId: componentId,
      currentConfigData: InstalledComponentStore.getConfigData(componentId, configId)
    };
  },

  getVersions() {
    return this.state.versions.slice(0, 5);
  },

  createOnChangeName(componentId, configId, version) {
    return function(name) {
      VersionsActionCreators.changeNewVersionName(componentId, configId, version, name);
    };
  },

  renderVersionInfo(version) {
    return (<span>
      #{version.get('version')} ({moment(version.get('created')).fromNow()} by {version.getIn(['creatorToken', 'description'], 'unknown')})
    </span>);
  },

  renderMenuItems(version, previousVersion, i) {
    var items = [];
    items.push(
      (<MenuItem header eventKey={version.get('version')}>
      {this.renderVersionInfo(version)}
      </MenuItem>)
    );
    items.push(
      (
        <MenuItem header>{version.get('changeDescription') || 'No description.'}</MenuItem>
      )
    );
    if (version.get('version') > 1) {
      items.push(this.renderDiffMenuItem(version, previousVersion));
    }
    if (i === 0) {
      items.push(
        (
          <CopyVersionMenuItem
            version={version}
            onCopy={createVersionOnCopy(this.state.componentId, this.state.configId, version.get('version'), this.state.newVersionNames.get(version.get('version')))}
            onChangeName={this.createOnChangeName(this.state.componentId, this.state.configId, version.get('version'))}
            newVersionName={this.state.newVersionNames.get(version.get('version'))}
            isDisabled={this.state.isPending}
            isPending={this.state.pendingActions.getIn([version.get('version'), 'copy'])}
          />
        )
      );
    } else {
      items.push(
        (<RollbackVersionMenuItem
           version={version}
           onRollback={createVersionOnRollback(this.state.componentId, this.state.configId, version.get('version'))}
           isDisabled={this.state.isPending}
           isPending={this.state.pendingActions.getIn([version.get('version'), 'rollback'])}
         />)
      );
    }
    // if it is not the first version show compare diff menu item

    items.push(
      (<MenuItem divider/>)
    );
    return items;
  },

  prepareVersionsDiffData(version, previousVersion) {
    const componentId = this.state.componentId;
    const configId = this.state.configId;
    const version1 = version.get('version');
    const version2 = previousVersion.get('version');
    return VersionsActionCreators.loadTwoComponentConfigVersions(componentId, configId, version1, version2);
  },

  renderDiffMenuItem(version, previousVersion) {
    return (
      <DiffMenuItem
        isDisabled={this.state.isPending}
        isPending={this.state.pendingActions.getIn([version.get('version'), 'config'])}
        onLoadVersionConfig={() => this.prepareVersionsDiffData(version, previousVersion)}
        version={version}
        previousVersion={previousVersion}

      />
    );
  },

  dropdownTitle() {
    return (
      <span>
        {this.props.firstVersionAsTitle ? this.renderVersionInfo(this.state.versions.get(0)) : 'Versions'}
      </span>
    );
  },

  render() {
    return (
      <span>
        <DropdownButton bsSize={this.props.dropDownButtonSize}
          title={this.dropdownTitle()} pullRight className="kbcVersionsButton">
          {
            this.getVersions().map(function(version, i) {
              const previousVersion = getPreviousVersion(this.state.versions, version);
              return this.renderMenuItems(version, previousVersion, i);
            }, this).toArray()
          }
          {this.renderAllVersionsLink()}
        </DropdownButton>
      </span>
    );
  },

  renderAllVersionsLink() {
    const routeName = this.props.allVersionsRouteName || `${this.state.componentId}-versions`;
    let params = {};
    params[this.props.configIdParam] = this.state.configId;
    // generic ui needs parameter component but custom uis dont needed at all i guess
    params.component = this.state.componentId;
    var href = this.state.router.makeHref(routeName, params);
    return (
      <MenuItem href={href}>
        Show all versions
      </MenuItem>
    );
  }
});
