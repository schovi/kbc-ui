import React, {PropTypes} from 'react';
import {Button, Input} from 'react-bootstrap';
import {Steps, COMPONENT_ID} from '../constants';
import AuthorizationRow from '../../oauth-v2/react/AuthorizationRow';
import WizardCommon from './wizard/WizardCommon';
import WizardStep from './wizard/WizardStep';
import {Loader} from 'kbc-react-components';
import DeleteConfigurationButton from '../../components/react/components/DeleteConfigurationButton';


export default React.createClass({
  propTypes: {
    step: PropTypes.string.isRequired,
    onStepChange: PropTypes.func.isRequired,
    oauthCredentials: PropTypes.object,
    oauthCredentialsId: PropTypes.string,
    isSaving: PropTypes.bool,
    onSave: PropTypes.func.isRequired,
    componentId: PropTypes.string.isRequired,
    configId: PropTypes.string.isRequired,
    settings: PropTypes.object.isRequired,
    onChange: PropTypes.func.isRequired,
    isStatic: PropTypes.bool
  },

  render() {
    console.log('render', this.props.step);
    return (
      <WizardCommon activeStep={this.props.step} goToStep={this.goToStep}>
        {this.authorizationStep()}
        <WizardStep step={Steps.STEP_USER_TIMELINE} title="User Timeline">
          <div className="row">
            <div className="col-md-8">
              <Input
                type="text"
                value={this.props.settings.get('userTimelineScreenName')}
                onChange={this.onUserTimelineChange}
                label="Screen name"
                help="User timeline will be fetched."
                disabled={this.props.isStatic}
                />
            </div>
          </div>
          <div className="row">
            <div className="pull-right">
              {this.props.isSaving ? <Loader/> : null}
              &nbsp;
              &nbsp;
              <DeleteConfigurationButton
                componentId={this.props.componentId}
                configId={this.props.configId}
                />
              <Button
                bsStyle="link"
                style={{marginLeft: '10px'}}
                onClick={this.goToAuthorization}
                >
                Previous
              </Button>
              <Button
                bsStyle="primary"
                style={{marginLeft: '10px'}}
                onClick={this.goToMentions}
                disabled={!this.props.oauthCredentials}
                >
                Continue
              </Button>
            </div>
          </div>
        </WizardStep>
        <WizardStep step={Steps.STEP_MENTIONS} title="Mentions">
          <div className="row">
            <div className="col-md-8">
              <p>Mentions of authorized user will be fetched.</p>
            </div>
          </div>
          <div className="row">
            <div className="pull-right">
              {this.props.isSaving ? <Loader/> : null}
              &nbsp;
              &nbsp;
              <DeleteConfigurationButton
                componentId={this.props.componentId}
                configId={this.props.configId}
                />
              <Button
                bsStyle="link"
                style={{marginLeft: '10px'}}
                onClick={this.goToUserTimeline}
                >
                Previous
              </Button>
              <Button
                bsStyle="primary"
                style={{marginLeft: '10px'}}
                onClick={this.goToFollowers}
                disabled={!this.props.oauthCredentials}
                >
                Continue
              </Button>
            </div>
          </div>
        </WizardStep>
        <WizardStep step={Steps.STEP_FOLLOWERS} title="Followers List">
          <div className="row">
            <div className="col-md-8">
              <Input
                type="text"
                value={this.props.settings.get('followersScreenName')}
                onChange={this.onFollowersChange}
                label="Screen name"
                help="Account's followers will be fetched."
                disabled={this.props.isStatic}
                />
            </div>
          </div>
          <div className="row">
            <div className="pull-right">
              {this.props.isSaving ? <Loader/> : null}
              &nbsp;
              &nbsp;
              <DeleteConfigurationButton
                componentId={this.props.componentId}
                configId={this.props.configId}
                />
              <Button
                bsStyle="link"
                style={{marginLeft: '10px'}}
                onClick={this.goToMentions}
                >
                Previous
              </Button>
              <Button
                bsStyle="primary"
                style={{marginLeft: '10px'}}
                onClick={this.goToSearch}
                disabled={!this.props.oauthCredentials}
                >
                Continue
              </Button>
            </div>
          </div>
        </WizardStep>
        <WizardStep step={Steps.STEP_SEARCH} title="Search Tweets">
          <div className="row">
            <div className="col-md-8">
              <Input
                type="text"
                value={this.props.settings.getIn(['search', 'query'])}
                onChange={this.onSearchQueryChange}
                label="Query"
                disabled={this.props.isStatic}
                />
            </div>
          </div>
          <div className="row">
            <div className="pull-right">
              {this.props.isSaving ? <Loader/> : null}
              &nbsp;
              &nbsp;
              <DeleteConfigurationButton
                componentId={this.props.componentId}
                configId={this.props.configId}
                />
              <Button
                bsStyle="link"
                style={{marginLeft: '10px'}}
                onClick={this.goToFollowers}
                >
                Previous
              </Button>
              <Button
                bsStyle="success"
                style={{marginLeft: '10px'}}
                onClick={this.props.onSave}
                >
                Save
              </Button>
            </div>
          </div>
        </WizardStep>
      </WizardCommon>
    );
  },

  authorizationStep() {
    if (this.props.isStatic) {
      return null;
    }
    return (
      <WizardStep step={Steps.STEP_AUTHORIZATION} title="Authorization" nextStep={Steps.STEP_USER_TIMELINE}>
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
        <div className="row">
          <div className="pull-right">
            {this.props.isSaving ? <Loader/> : null}
            &nbsp;
            &nbsp;
            <DeleteConfigurationButton
              componentId={this.props.componentId}
              configId={this.props.configId}
              />
            <Button
              bsStyle="primary"
              style={{marginLeft: '10px'}}
              onClick={this.goToUserTimeline}
              disabled={!this.props.oauthCredentials}
              >
              Continue
            </Button>
          </div>
        </div>
      </WizardStep>
    );
  },

  goToAuthorization() {
    this.goToStep(Steps.STEP_AUTHORIZATION);
  },

  goToMentions() {
    this.goToStep(Steps.STEP_MENTIONS);
  },

  goToUserTimeline() {
    this.goToStep(Steps.STEP_USER_TIMELINE);
  },

  goToFollowers() {
    this.goToStep(Steps.STEP_FOLLOWERS);
  },

  goToSearch() {
    this.goToStep(Steps.STEP_SEARCH);
  },

  goToStep(step) {
    console.log('go to step', step);
    this.props.onStepChange(step);
  },

  onUserTimelineChange(e) {
    this.props.onChange(this.props.settings.set('userTimelineScreenName', e.target.value));
  },

  onFollowersChange(e) {
    this.props.onChange(this.props.settings.set('followersScreenName', e.target.value));
  },

  onSearchQueryChange(e) {
    this.props.onChange(this.props.settings.setIn(['search', 'query'], e.target.value));
  }
});