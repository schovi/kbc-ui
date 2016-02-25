import React, {PropTypes} from 'react';
import _ from 'underscore';
import {ButtonToolbar, Button, Modal, Input} from 'react-bootstrap';
import AuthorizationForm from './AuthorizationForm';
export default React.createClass({
  propTypes: {
    componentId: PropTypes.string.isRequired,
    id: PropTypes.string.isRequired,
    show: PropTypes.bool,
    onHideFn: PropTypes.func
  },

  getInitialState() {
    return {
      authorizedFor: ''
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
              <Input
                label="Authorize For"
                type="text"
                name="authorizedFor"
                help="Used afterwards as a description of the authorized account"
                labelClassName="col-xs-3"
                wrapperClassName="col-xs-9"
                defaultValue={this.state.authorizedFor}
                onChange={this.changeAuthorizedFor}
                autoFocus={true}
              />
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

  changeAuthorizedFor(e) {
    this.setState({
      authorizedFor: e.target.value
    });
  }

});
