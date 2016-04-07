import React, {PropTypes} from 'react';
import _ from 'underscore';
import {TabbedArea, TabPane, ButtonToolbar, Button, Modal} from 'react-bootstrap';
import Clipboard from '../../../react/common/Clipboard';
import AuthorizationForm from './AuthorizationForm';
import * as oauthUtils from '../OauthUtils';
import {Loader} from 'kbc-react-components';

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
      generatingLink: false
    };
  },

  render() {
    return (
      <div className="static-modal">
        <Modal
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
              <TabbedArea key="tabbedarea" animation={false}>
                <TabPane key="general" eventKey="general" tab="Instant authorization">
                  {this.renderInstant()}
                </TabPane>
                <TabPane key="external" eventKey="external" tab="External authorization">
                  {this.renderExternal()}
                </TabPane>
              </TabbedArea>
            </Modal.Body>
            <Modal.Footer>
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
        <Clipboard text={this.state.externalLink} />
      </pre>
    : null
    );
    return (
      <div className="form-group">
        <div>
          <p className="form-control-static">
            <span>
             To authorize an account from non kbc user, generate a link to the external authorization app and send it to the user you want to have authorized account for. The generated link is valid for <strong>48</strong> hours and will not be stored anywhere.
            </span>
            {externalLink}
            <div>
              <button
                type="button"
                disabled={this.state.generatingLink}
                className="btn btn-primary"
                onClick={this.onGetExternalLink}>
          {(this.state.externalLink ? 'Regenerate Link' : 'Generate Link')}
              </button>
            {(this.state.generatingLink ? <Loader /> : null)}
            </div>
          </p>
        </div>
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
      <div style={{'padding-top': '10px'}} className="form-group">
        <div className="col-xs-12">
          <label className="control-label col-xs-3">
      Authorize For
          </label>
          <div className="col-xs-9">
            <input
              className="form-control"
              type="text"
              name="authorizedFor"
              help="Used afterwards as a description of the authorized account"
              defaultValue={this.state.authorizedFor}
              onChange={this.changeAuthorizedFor}
              autoFocus={true}
            />
            <div className="help-text">
              Used afterwards as a description of the authorized account
            </div>
          </div>
        </div>
      </div>
    );
    // labelClassName="col-xs-3"
    // wrapperClassName="col-xs-11"
  },
  changeAuthorizedFor(e) {
    this.setState({
      authorizedFor: e.target.value
    });
  }

});
