import React, {PropTypes} from 'react';
import {TabbedArea, TabPane, Button} from 'react-bootstrap';
import {Steps, COMPONENT_ID} from '../constants';
import AuthorizationRow from '../../oauth-v2/react/AuthorizationRow';

export default React.createClass({
  propTypes: {
    step: PropTypes.string.isRequired,
    onStepChange: PropTypes.func.isRequired,
    oauthCredentials: PropTypes.object,
    oauthCredentialsId: PropTypes.string
  },
  render() {
    return (
      <TabbedArea activeKey={this.props.step} onSelect={this.goToStep} animation={false}>
        <TabPane eventKey={Steps.STEP_AUTHORIZATION} tab="Authorization">
          <div className="row">
            <div className="col-md-8">
              <AuthorizationRow
                id={this.props.oauthCredentialsId}
                componentId={COMPONENT_ID}
                credentials={this.props.oauthCredentials}
                isResetingCredentials={false}
                onResetCredentials={this.deleteCredentials}

                />
            </div>
          </div>
        </TabPane>
      </TabbedArea>
    );
  },

  goToStep(step) {
    this.props.onStepChange(step);
  }
});