import React, {PropTypes} from 'react/addons';
import ConfigurationLink from '../components/ComponentConfigurationLink';
import RunConfigurationButton from '../components/RunComponentButton';
import DeleteButton from '../../../../react/common/DeleteButton';
import InstalledComponentsActionCreators from '../../InstalledComponentsActionCreators';

export default React.createClass({
  mixins: [React.addons.PureRenderMixin],
  propTypes: {
    config: PropTypes.object.isRequired,
    componentId: PropTypes.string.isRequired,
    isDeleting: PropTypes.bool.isRequired
  },

  render() {
    return (
      <tr>
        <td>
          <ConfigurationLink
            componentId={this.props.componentId}
            configId={this.props.config.get('id')}
            >
            <strong className="kbc-config-name">
              {this.props.config.get('name', '---')}
            </strong>
            {this.description()}
          </ConfigurationLink>
        </td>
        <td className="text-right kbc-component-buttons">
          <span className="kbc-component-author">
            Created by <strong>{this.props.config.getIn(['creatorToken', 'description'])}</strong>
          </span>
          <DeleteButton
            tooltip="Delete Configuration"
            isPending={this.props.isDeleting}
            confirm={this.deleteConfirmProps()}
            />
          <RunConfigurationButton
            title="Run"
            component={this.props.componentId}
            runParams={this.runParams()}

            >
              You are about to run component
            </RunConfigurationButton>
        </td>
      </tr>
    );
  },

  description() {
    if (!this.props.config.get('description')) {
      return null;
    }
    return (
      <small> - {this.props.config.get('description')}</small>
    );
  },

  deleteConfirmProps() {
    return {
      title: 'Delete Configuration',
      text: `Do you really want to delete configuration ${this.props.config.get('name')}?`,
      onConfirm: this.handleDelete
    };
  },

  runParams() {
    return () => ({config: this.props.config.get('id')});
  },

  handleDelete() {
    InstalledComponentsActionCreators.deleteConfiguration(this.props.componentId, this.props.config.get('id'));
  }
});