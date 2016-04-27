import React, {PropTypes} from 'react';
import _ from 'underscore';
import {TabbedArea, TabPane, ButtonToolbar, Button, Modal} from 'react-bootstrap';
import Clipboard from '../../../react/common/Clipboard';
import AuthorizationForm from './AuthorizationForm';
import * as oauthUtils from '../OauthUtils';
import {Loader} from 'kbc-react-components';

import './AuthorizationModal.less';

export default React.createClass({
  propTypes: {
    componentId: PropTypes.string.isRequired,
    id: PropTypes.string.isRequired,
    configId: PropTypes.string.isRequired,
    show: PropTypes.bool,
    onHideFn: PropTypes.func
  },

  getInitialState() {
    return {
      authorizedFor: '',
      externalLink: '',
      generatingLink: false,
      activeTab: 'general'
    };
  },

  render() {
    return (
      <div className="static-modal">
        <Modal
          className="kbc-authorization-modal"
          show={this.props.show}
          onHide={this.props.onHideFn}
        >
          <Modal.Header closeButton>
            <Modal.Title>
              Authorize
            </Modal.Title>
          </Modal.Header>
          <AuthorizationForm
            componentId={this.props.componentId}
            id={this.props.id}
          >
            <Modal.Body>
              <TabbedArea key="tabbedarea" activeKey={this.state.activeTab} onSelect={this.goToTab} animation={false}>
                <TabPane key="general" eventKey="general" tab="Instant authorization">
                  {this.renderInstant()}
                </TabPane>
                <TabPane key="external" eventKey="external" tab="External authorization">
                  {this.renderExternal()}
                </TabPane>
              </TabbedArea>
            </Modal.Body>
            <Modal.Footer>
              {this.state.activeTab === 'general' ? this.renderInstantButtons() : this.renderExternalButtons()}
            </Modal.Footer>
          </AuthorizationForm>
        </Modal>
      </div>
    );
  },

  renderExternal() {
    const externalLink = (
      this.state.externalLink ?
      <pre>
        <a href={this.state.externalLink} target="_blank">
        {this.state.externalLink}
        </a>
        <div style={{paddingTop: '10px'}}>
          <Clipboard text={this.state.externalLink} label="Copy link to clipboard" />
        </div>
      </pre>
    : null
    );
    return (
      <div>
          <p style={{marginTop: '20px'}}>
            <span>
             To authorize an account from non Keboola Connection user, generate a link to the external authorization app and send it to the user you want to have authorized account for. The generated link is valid for <strong>48</strong> hours and will not be stored anywhere.
            </span>
            </p>
            {externalLink}
      </div>
    );
  },

  onGetExternalLink() {
    this.setState({generatingLink: true});
    oauthUtils.generateLink(this.props.componentId, this.props.configId)
              .then((link) => {
                console.log('external link', link);
                this.setState({generatingLink: false, externalLink: link});
              }
              );
  },

  renderInstant() {
    return (
      <div style={{'padding-top': '20px'}} className="form-group">
        <div className="col-xs-12">
          <label className="control-label col-xs-2">
      Description
          </label>
          <div className="col-xs-9">
            <input
              className="form-control"
              type="text"
              name="authorizedFor"
              help="Describe this authorization, e.g by account name."
              defaultValue={this.state.authorizedFor}
              onChange={this.changeAuthorizedFor}
              autoFocus={true}
            />
            <span className="help-text">
              Describe this authorization, e.g. by account name.
            </span>
          </div>
        </div>
      </div>
    );
  },

  renderInstantButtons() {
    return (
      <ButtonToolbar>
        <Button
            bsStyle="link"
            onClick={this.props.onHideFn}>Cancel
        </Button>
        <Button
            bsStyle="success"
            type="submit"
            disabled={_.isEmpty(this.state.authorizedFor)}
        ><span>Authorize</span>
        </Button>
      </ButtonToolbar>
    );
  },

  renderExternalButtons() {
    return (
      <ButtonToolbar>
        {(this.state.generatingLink ? <Loader /> : null)}
        <Button
            bsStyle="link"
            onClick={this.props.onHideFn}>Cancel
        </Button>
        <Button
            type="button"
            disabled={this.state.generatingLink}
            bsStyle="success"
            onClick={this.onGetExternalLink}>
          {(this.state.externalLink ? 'Regenerate Link' : 'Generate Link')}
        </Button>
      </ButtonToolbar>
    );
  },

  changeAuthorizedFor(e) {
    this.setState({
      authorizedFor: e.target.value
    });
  },

  goToTab(tab) {
    this.setState({
      activeTab: tab
    });
  }

});
