import React from 'react';
import {Modal, Input} from 'react-bootstrap';
import {Map} from 'immutable';
import {createTransformation} from '../../ActionCreators';

import ConfirmButtons from '../../../../react/common/ConfirmButtons';




export default React.createClass({
    propTypes: {
        bucket: React.PropTypes.object.isRequired
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
        return(
            <form className="form-horizontal">
                <Input
                    type="text"
                    value={this.state.data.get('name')}
                    onChange={this.handleChange.bind(this, 'name')}
                    placeholder="Name"
                    label="Name"
                    ref="name"
                    labelClassName="col-sm-4"
                    wrapperClassName="col-sm-6" />
                <Input
                    type="textarea"
                    value={this.state.data.get('description')}
                    onChange={this.handleChange.bind(this, 'description')}
                    placeholder="Description"
                    label="Description"
                    labelClassName="col-sm-4"
                    wrapperClassName="col-sm-6" />
                <Input
                    type="select"
                    label="Backend"
                    value={this.state.data.get('backend')}
                    onChange={this.handleChange.bind(this, 'backend')}
                    labelClassName="col-sm-4"
                    wrapperClassName="col-sm-6" >
                    {this.backendOptions()}
                </Input>
            </form>
        );
    },

    backendOptions() {
      return [
          {value: 'mysql', label: 'MySQL'},
          {value: 'redshift', label: 'Redshift'},
          {value: 'r', label: 'R'},
      ].map((option) => {
            return (
                <option value={option.value}>{option.label}</option>
            );
          });
    },


    isValid() {
      return this.state.data.get('name').length > 0;
    },

    handleChange(field, e) {
        this.setState({
            data: this.state.data.set(field, e.target.value.trim())
        });
    },

    handleCreate() {
        this.setState({
           data: this.state.data.set('isSaving', true)
        });
        createTransformation(this.props.bucket.get('id'), this.prepareDataForCreate(this.state.data))
        .then(this.props.onRequestHide)
        .catch(() => {
                this.setState({
                    data: this.state.data.set('isSaving', false)
                });
            });
    },

    prepareDataForCreate(data) {
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
            case 'r':
                newData = newData.set('backend', 'docker').set('type', 'r');
                break;
        }

        return newData;
    }

});