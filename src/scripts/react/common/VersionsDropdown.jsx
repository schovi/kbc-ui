import React from 'react';
import {DropdownButton, MenuItem} from 'react-bootstrap';
import RollbackVersionMenuItem from './RollbackVersionMenuItem';
import CopyVersionMenuItem from './CopyVersionMenuItem';
import createStoreMixin from '../mixins/createStoreMixin';
import VersionsStore from '../../modules/components/stores/VersionsStore';
import moment from 'moment';
import createVersionOnRollback from '../../utils/createVersionOnRollback';
import createVersionOnCopy from '../../utils/createVersionOnCopy';
import VersionsActionCreators from '../../../scripts/modules/components/VersionsActionCreators';
import {Link} from 'react-router';

export default React.createClass({
  mixins: [createStoreMixin(VersionsStore)],

  propTypes: {
    componentId: React.PropTypes.string.isRequired,
    configId: React.PropTypes.string.isRequired
  },

  getStateFromStores() {
    return {
      versions: VersionsStore.getVersions(this.props.componentId, this.props.configId),
      newVersionNames: VersionsStore.getNewVersionNames(this.props.componentId, this.props.configId),
      isPending: VersionsStore.isPending(this.props.componentId, this.props.configId)
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

  renderMenuItems(version, i) {
    var items = [];
    items.push(
      (<MenuItem header eventKey={version.get('version')}>
        #{version.get('version')} ({moment(version.get('created')).fromNow()} by {version.getIn(['creatorToken', 'description'], 'unknown')})
      </MenuItem>)
    );
    items.push(
      (
        <MenuItem header>{version.get('changeDescription')}</MenuItem>
      )
    );

    if (i === 0) {
      items.push(
        (
          <CopyVersionMenuItem
            version={version}
            onCopy={createVersionOnCopy(this.props.componentId, this.props.configId, version.get('version'), this.state.newVersionNames.get(version.get('version')))}
            onChangeName={this.createOnChangeName(this.props.componentId, this.props.configId, version.get('version'))}
            newVersionName={this.state.newVersionNames.get(version.get('version'))}
            isPending={this.state.isPending}
          />
        )
      );
    } else {
      items.push(
        (<RollbackVersionMenuItem
          version={version}
          onRollback={createVersionOnRollback(this.props.componentId, this.props.configId, version.get('version'))}
          isPending={this.state.isPending}
        />)
      );
    }
    items.push(
      (<MenuItem divider/>)
    );
    return items;
  },

  render() {
    return (
      <span>
        <DropdownButton title="Versions" pullRight className="kbcVersionsButton">
          {this.getVersions().map(function(version, i) {
            return this.renderMenuItems(version, i);
          }, this).toArray()}
          {this.renderAllVersionsLink()}
        </DropdownButton>
      </span>
    );
  },


  renderAllVersionsLink() {
    if (this.props.componentId === 'transformation') {
      return (
        <MenuItem>
          <Link
            to="transformationVersions"
            params={{bucketId: this.props.configId}}
          >
            Show all versions
          </Link>
        </MenuItem>
      );
    } else {
      return null;
    }
  }
});
