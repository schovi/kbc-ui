import React, {PropTypes} from 'react';
import CredentialsForm from './CredentialsForm';
import SSLForm from './SSLForm';
import FixedIP from './FixedIP';
import {TabbedArea, TabPane} from 'react-bootstrap';

export default React.createClass({
  propTypes: {
    credentials: PropTypes.object.isRequired,
    isEditing: PropTypes.bool.isRequired,
    onChange: PropTypes.func.isRequired,
    configId: PropTypes.string.isRequired,
    componentId: PropTypes.string.isRequired,
    credentialsTemplate: PropTypes.object.isRequired,
    hasSshTunnel: PropTypes.func.isRequired
  },

  render() {
    return (
      <div className="container-fluid kbc-main-content">
        <TabbedArea defaultActiveKey="db" animation={false}>
          <TabPane eventKey="db" tab="Database Credentials">
            <CredentialsForm
              credentials={this.props.credentials}
              enabled={this.props.isEditing}
              onChange={this.props.onChange}
              componentId={this.props.componentId}
              configId={this.props.configId}
              credentialsTemplate={this.props.credentialsTemplate}
              hasSshTunnel={this.props.hasSshTunnel}
            />
          </TabPane>
          {this.renderSSLForm()}
          <TabPane eventKey="fixedIp" tab="Fixed IP">
            <FixedIP
              credentials={this.props.credentials}
            />
          </TabPane>
        </TabbedArea>
      </div>
    );
  },

  renderSSLForm() {
    if (this.props.componentId === 'keboola.ex-db-mysql') {
      return (
          <TabPane eventKey="ssl" tab="SSL">
            <SSLForm
                credentials={this.props.credentials}
                enabled={this.props.isEditing}
                onChange={this.props.onChange}
                componentId={this.props.componentId}
                />
          </TabPane>
      );
    }
  }

});
