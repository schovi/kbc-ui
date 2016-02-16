import React, {PropTypes} from 'react';
import {Modal, Input, ButtonToolbar, Button} from 'react-bootstrap';

export default React.createClass({
  propTypes: {
    xsrf: PropTypes.string.isRequired,
    organizations: PropTypes.object.isRequired,
    urlTemplates: PropTypes.object.isRequired,
    projectTemplates: PropTypes.object.isRequired,
    isOpen: PropTypes.bool,
    onHide: PropTypes.func.isRequired
  },

  getInitialState() {
    return {
      name: '',
      type: 'demo',
      isSaving: false
    };
  },


  render() {
    return (
      <Modal show={this.props.isOpen} onHide={this.props.onHide}>
        <Modal.Header>
          <Modal.Title>New Project</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <form
            className="form-horizontal"
            ref="projectCreateForm"
            method="post"
            action={this.props.urlTemplates.get('createProject')}
            >
              <Input
                label="Name"
                name="name"
                ref="name"
                autoFocus={true}
                value={this.state.name}
                onChange={this.handleNameChange}
                type="text"
                placeholder="My Project"
                labelClassName="col-sm-4"
                wrapperClassName="col-sm-6"
                />
            <Input
              label="Organization"
              name="organizationId"
              type="select"
              labelClassName="col-sm-4"
              wrapperClassName="col-sm-6">
              {this.organizationOptions()}
              </Input>
            <Input
              type="hidden"
              name="xsrf"
              value={this.props.xsrf}
              />
            <div>
              <div className="form-group">
                <label className="control-label col-sm-4">
                  Type
                </label>
                <div className="col-sm-6">
                  <p className="form-control-static">
                    <span className="help-block">
                      Project can be upgraded anytime later.
                    </span>
                  </p>
                </div>
              </div>
              {this.types()}
            </div>
            </form>
        </Modal.Body>
        <Modal.Footer>
          <ButtonToolbar>
            <Button onClick={this.props.onHide} bsStyle="link">
              Cancel
            </Button>
            <Button bsStyle="primary" onClick={this.handleCreate} disabled={!this.isValid() || this.state.isSaving}>
              Create Project
            </Button>
          </ButtonToolbar>
        </Modal.Footer>
      </Modal>
    );
  },

  organizationOptions() {
    return this.props.organizations.map( (organization) => {
      return (
        <option value={organization.get('id')} key={organization.get('id')}>
          {organization.get('name')}
        </option>
      );
    }).toArray();
  },

  types() {
    return this.props.projectTemplates.map((template) => {
      return (
        <Input
          type="radio"
          label={template.get('name')}
          name="type"
          checked={template.get('stringId') === this.state.type}
          help={template.get('description')}
          value={template.get('stringId')}
          onChange={this.handleTypeChange}
          wrapperClassName="col-xs-offset-4 col-xs-6"
          />
      );
    });
  },

  handleNameChange(e) {
    this.setState({
      name: e.target.value
    });
  },

  handleTypeChange(e) {
    this.setState({
      type: e.target.value
    });
  },

  isValid() {
    return this.state.name !== '';
  },

  handleCreate() {
    this.setState({
      isSaving: true
    });
    this.refs.projectCreateForm.getDOMNode().submit();
  }
});