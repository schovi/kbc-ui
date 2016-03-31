import React from 'react';
import CreatedWithIcon from '../../../../react/common/CreatedWithIcon';
import RollbackVersionButton from '../../../../react/common/RollbackVersionButton';
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
    newVersionName: React.PropTypes.string
  },

  onChangeName(name) {
    VersionsActionCreators.changeNewVersionName(this.props.componentId, this.props.configId, this.props.version.get('version'), name);
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
          <RollbackVersionButton
            version={this.props.version}
            onRollback={createVersionOnRollback(this.props.componentId, this.props.configId, this.props.version.get('version'))}
            />
          <CopyVersionButton
            version={this.props.version}
            onCopy={createVersionOnCopy(this.props.componentId, this.props.configId, this.props.version.get('version'), this.props.newVersionName)}
            onChangeName={this.onChangeName}
            newVersionname={this.props.newVersionName}
            />
        </td>
      </tr>
    );
  }
});
