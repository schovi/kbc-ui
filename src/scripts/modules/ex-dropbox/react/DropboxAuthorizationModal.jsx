import _ from 'underscore';
import React from 'react';
import ApplicationStore from '../../../stores/ApplicationStore';
import { Button, ButtonToolbar, Modal, Input } from 'react-bootstrap';
import RouterStore from '../../../stores/RoutesStore';

export default React.createClass({

  displayName: 'DropboxAuthorizeModal',

  propTypes: {
    configId: React.PropTypes.string.isRequired,
    redirectRouterPath: React.PropTypes.string,
    credentialsId: React.PropTypes.string,
    onRequestHide: React.PropTypes.func
  },

  getInitialState() {
    let oauthUrl = 'https://syrup.keboola.com/oauth/auth20';

    return {
      description: '',
      token: ApplicationStore.getSapiTokenString(),
      oauthUrl: oauthUrl,
      router: RouterStore.getRouter()
    };
  },

  getDefaultProps() {
    return {
      redirectRouterPath: 'ex-dropbox-oauth-redirect'
    };
  },

  componentDidMount() {
    return this.refs.description.getInputDOMNode().focus();
  },

  eventChange(event) {
    this.setState({
      description: event.target.value
    });
  },

  render() {
    return (
      <Modal onHide={this.props.onRequestHide}>
        <Modal.Header closeButton>
          <Modal.Title>Authorize Dropbox Account</Modal.Title>
        </Modal.Header>
        <form className="form-horizontal" action={this.state.oauthUrl} method="POST">
          {this.createHiddenInput('api', 'ex-dropbox')}
          {this.createHiddenInput('id', this.props.credentialsId || this.props.configId )}
          {this.createHiddenInput('token', this.state.token)}
          {this.createHiddenInput('returnUrl', this.getRedirectUrl())}

          <Modal.Body>
            <Input
              label="Dropbox Email"
              type="text"
              ref="description"
              name="description"
              help="Used afterwards as a description of the authorized account"
              labelClassName="col-xs-3"
              wrapperClassName="col-xs-9"
              defaultValue={this.state.description}
              onChange={this.eventChange}
            />
          </Modal.Body>
          <Modal.Footer>
            <ButtonToolbar>
              <Button
                bsStyle="link"
                onClick={this.props.onRequestHide}>Cancel
              </Button>
              <Button
                bsStyle="success"
                type="submit"
                disabled={_.isEmpty(this.state.description)}
              ><span><i className="fa fa-fw fa-dropbox" />Authorize</span>
              </Button>
            </ButtonToolbar>
          </Modal.Footer>
        </form>
      </Modal>
    );
  },

  createHiddenInput(name, value) {
    return (
      <input
        name={name}
        type="hidden"
        value={value}
      />

    );
  },

  getRedirectUrl() {
    let origin = ApplicationStore.getSapiUrl();
    let url = this.state.router.makeHref(this.props.redirectRouterPath, {config: this.props.configId});
    let result = `${origin}${url}`;

    return result;
  }
});