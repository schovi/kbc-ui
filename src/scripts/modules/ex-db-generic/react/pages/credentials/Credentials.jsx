import React, {PropTypes} from 'react';
import CredentialsForm from './CredentialsForm';
import SSLForm from './SSLForm';
import {TabbedArea, TabPane} from 'react-bootstrap';

export default React.createClass({
  propTypes: {
    savedCredentials: PropTypes.object.isRequired,
    credentials: PropTypes.object.isRequired,
    isEditing: PropTypes.bool.isRequired,
    onChange: PropTypes.func.isRequired,
    configId: PropTypes.string.isRequired,
    componentId: PropTypes.string.isRequired,
    credentialsTemplate: PropTypes.object.isRequired,
    hasSshTunnel: PropTypes.func.isRequired,
    actionsProvisioning: PropTypes.object.isRequired
  },

  render() {
    return (
      <div className="container-fluid kbc-main-content">
        <TabbedArea defaultActiveKey="db" animation={false}>
          <TabPane eventKey="db" tab="Database Credentials">
            <CredentialsForm
              savedCredentials={this.props.savedCredentials}
              credentials={this.props.credentials}
              enabled={this.props.isEditing}
              onChange={this.props.onChange}
              componentId={this.props.componentId}
              configId={this.props.configId}
              credentialsTemplate={this.props.credentialsTemplate}
              hasSshTunnel={this.props.hasSshTunnel}
              actionsProvisioning={this.props.actionsProvisioning}
            />
          </TabPane>
          {this.renderSSLForm()}
        </TabbedArea>
      </div>
    );
  },

  renderSSLForm() {
    if (this.props.componentId === 'keboola.ex-db-mysql' || this.props.componentId === 'keboola.ex-db-mysql-custom') {
      return (
          <TabPane eventKey="ssl" tab="SSL">
            <SSLForm
                credentials={this.props.credentials}
                enabled={this.props.isEditing}
                onChange={this.props.onChange}
                componentId={this.props.componentId}
                actionsProvisioning={this.props.actionsProvisioning}
                />
          </TabPane>
      );
    }
  }

});
