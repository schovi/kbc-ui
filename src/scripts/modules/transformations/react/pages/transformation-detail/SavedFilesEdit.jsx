import React, {PropTypes} from 'react';
import ConfirmButtons from '../../../../../react/common/ConfirmButtons';
import Select from 'react-select';
import {fromJS} from 'immutable';

export default React.createClass({
  propTypes: {
    tags: PropTypes.object.isRequired,
    isSaving: PropTypes.bool.isRequired,
    onChange: PropTypes.func.isRequired,
    onCancel: PropTypes.func.isRequired,
    onSave: PropTypes.func.isRequired
  },

  render() {
    return (
      <div className="well">
        <div className="form-group">
          <Select
            name="requires"
            value={this.props.tags.toArray()}
            multi="true"
            disabled={this.props.isSaving}
            allowCreate="true"
            delimiter=","
            onChange={this.handleValueChange}
            placeholder="Add tags..."
            />
        </div>
        <ConfirmButtons
          isSaving={this.props.isSaving}
          onSave={this.props.onSave}
          onCancel={this.props.onCancel}
          placement="left"
          />
      </div>
    );
  },

  handleValueChange(newValue, newArray) {
    const values = fromJS(newArray).map((item) => item.get('value'));
    this.props.onChange(values);
  }

});
