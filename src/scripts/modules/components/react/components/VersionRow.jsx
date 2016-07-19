import React from 'react';
import CreatedWithIcon from '../../../../react/common/CreatedWithIcon';
import RollbackVersionButton from '../../../../react/common/RollbackVersionButton';
import DiffVersionButton from '../../../../react/common/DiffVersionButton';
import CopyVersionButton from '../../../../react/common/CopyVersionButton';
import createVersionOnRollback from '../../../../utils/createVersionOnRollback';
import createVersionOnCopy from '../../../../utils/createVersionOnCopy';
import VersionsActionCreators from '../../VersionsActionCreators';
import ImmutableRenderMixin from '../../../../react/mixins/ImmutableRendererMixin';

export default React.createClass({
  mixins: [ImmutableRenderMixin],

  propTypes: {
    componentId: React.PropTypes.string.isRequired,
    configId: React.PropTypes.string.isRequired,
    hideRollback: React.PropTypes.bool,
    version: React.PropTypes.object.isRequired,
    previousVersion: React.PropTypes.object.isRequired,
    newVersionName: React.PropTypes.string,
    isRollbackPending: React.PropTypes.bool,
    isRollbackDisabled: React.PropTypes.bool,
    isCopyPending: React.PropTypes.bool,
    isCopyDisabled: React.PropTypes.bool,
    isDiffPending: React.PropTypes.bool,
    isDiffDisabled: React.PropTypes.bool,
    onPrepareVersionsDiffData: React.PropTypes.func
  },

  onChangeName(name) {
    VersionsActionCreators.changeNewVersionName(this.props.componentId, this.props.configId, this.props.version.get('version'), name);
  },

  renderRollbackButton() {
    if (this.props.hideRollback) {
      return null;
    }
    return (
      <RollbackVersionButton
        version={this.props.version}
        onRollback={createVersionOnRollback(this.props.componentId, this.props.configId, this.props.version.get('version'))}
        isDisabled={this.props.isRollbackDisabled}
        isPending={this.props.isRollbackPending}
        />
    );
  },

  renderDiffButton() {
    return (
      <DiffVersionButton
        isDisabled={this.props.isDiffDisabled}
        isPending={this.props.isDiffPending}
        onLoadVersionConfig={this.props.onPrepareVersionsDiffData}
        version={this.props.version}
        previousVersion={this.props.previousVersion}
      />
    );
  },

  render() {
    return (
      <tr>
        <td>
          #{this.props.version.get('version')}
        </td>
        <td >
          {this.props.version.get('changeDescription') ? this.props.version.get('changeDescription') : (<small><em>No description</em></small>)}
        </td>
        <td>
          <CreatedWithIcon
            createdTime={this.props.version.get('created')}
          />
        </td>
        <td>
          {this.props.version.getIn(['creatorToken', 'description']) ? this.props.version.getIn(['creatorToken', 'description']) : (<small><em>Unknown</em></small>)}
        </td>
        <td className="text-right">
          {this.renderRollbackButton()}
          {this.renderDiffButton()}
          <CopyVersionButton
            version={this.props.version}
            onCopy={createVersionOnCopy(this.props.componentId, this.props.configId, this.props.version.get('version'), this.props.newVersionName)}
            onChangeName={this.onChangeName}
            newVersionName={this.props.newVersionName}
            isDisabled={this.props.isCopyDisabled}
            isPending={this.props.isCopyPending}
            />
        </td>
      </tr>
    );
  }
});
