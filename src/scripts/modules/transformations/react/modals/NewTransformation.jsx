import React from 'react';
import {Modal, Input} from 'react-bootstrap';
import {Map} from 'immutable';
import {createTransformation} from '../../ActionCreators';

import ConfirmButtons from '../../../../react/common/ConfirmButtons';

function prepareDataForCreate(data) {
  let newData = Map({
    name: data.get('name'),
    description: data.get('description')
  });

  switch (data.get('backend')) {
    case 'mysql':
      newData = newData.set('backend', 'mysql').set('type', 'simple');
      break;
    case 'redshift':
      newData = newData.set('backend', 'redshift').set('type', 'simple');
      break;
    case 'snowflake':
      newData = newData.set('backend', 'snowflake').set('type', 'simple');
      break;
    case 'r':
      newData = newData.set('backend', 'docker').set('type', 'r');
      break;
    case 'python':
      newData = newData.set('backend', 'docker').set('type', 'python');
      break;
    default:
      throw new Error('Unknown backend ' + data.get('backend'));
  }

  return newData;
}

export default React.createClass({
  propTypes: {
    bucket: React.PropTypes.object.isRequired,
    onRequestHide: React.PropTypes.func.isRequired
  },

  getInitialState() {
    return {
      data: Map({
        isSaving: false,
        name: '',
        description: '',
        backend: 'mysql'
      })
    };
  },

  componentDidMount() {
    this.refs.name.getInputDOMNode().focus();
  },

  render() {
    return (
      <Modal {...this.props} title="New Transformation">
        <div className="modal-body">
          {this.form()}
        </div>
        <div className="modal-footer">
          <ConfirmButtons
            isSaving={this.state.data.get('isSaving')}
            isDisabled={!this.isValid()}
            saveLabel="Create"
            onCancel={this.props.onRequestHide}
            onSave={this.handleCreate}
            />
        </div>
      </Modal>
    );
  },

  form() {
    return (
      <form className="form-horizontal" onSubmit={this.handleSubmit}>
        <p className="help-block">
          Create new transformation in bucket <strong>{ this.props.bucket.get('name') }</strong>
        </p>
        <Input
          type="text"
          value={this.state.data.get('name')}
          onChange={this.handleChange.bind(this, 'name')}
          placeholder="Name"
          label="Name"
          ref="name"
          labelClassName="col-sm-4"
          wrapperClassName="col-sm-6"/>
        <Input
          type="textarea"
          value={this.state.data.get('description')}
          onChange={this.handleChange.bind(this, 'description')}
          placeholder="Description"
          label="Description"
          labelClassName="col-sm-4"
          wrapperClassName="col-sm-6"/>
        <Input
          type="select"
          label="Backend"
          value={this.state.data.get('backend')}
          onChange={this.handleChange.bind(this, 'backend')}
          labelClassName="col-sm-4"
          wrapperClassName="col-sm-6"
          help={this.snowflakeWarning()}>
          {this.backendOptions()}
        </Input>
      </form>
    );
  },

  snowflakeWarning() {
    if (this.state.data.get('backend') === 'snowflake') {
      return (
        <span>
          Snowflake support is experimental. Contact <a href="mailto:support@keboola.com">support@keboola.com</a> for more details.
        </span>
      );
    } else {
      return (<span></span>);
    }
  },

  backendOptions() {
    return [
      {value: 'mysql', label: 'MySQL'},
      {value: 'redshift', label: 'Redshift'},
      {value: 'snowflake', label: 'Snowflake'},
      {value: 'r', label: 'R'},
      {value: 'python', label: 'Python'}
    ].map(function(option) {
      return (
        <option value={option.value} key={option.value}>{option.label}</option>
      );
    });
  },


  isValid() {
    return this.state.data.get('name').length > 0;
  },

  handleChange(field, e) {
    this.setState({
      data: this.state.data.set(field, e.target.value)
    });
  },

  handleSubmit(e) {
    e.preventDefault();
    if (this.isValid()) {
      this.handleCreate();
    }
  },

  handleCreate() {
    this.setState({
      data: this.state.data.set('isSaving', true)
    });
    createTransformation(this.props.bucket.get('id'), prepareDataForCreate(this.state.data))
      .then(this.props.onRequestHide)
      .catch(() => {
        this.setState({
          data: this.state.data.set('isSaving', false)
        });
      });
  }

});
