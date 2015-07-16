import React, {PropTypes} from 'react';
import ConfirmButtons from '../../../../../react/common/ConfirmButtons';
import Select from 'react-select';
import {fromJS} from 'immutable';

export default React.createClass({
  propTypes: {
    packages: PropTypes.object.isRequired,
    isSaving: PropTypes.bool.isRequired,
    onChange: PropTypes.func.isRequired,
    onCancel: PropTypes.func.isRequired,
    onSave: PropTypes.func.isRequired
  },

  render() {
    return (
      <div className="well">
        <p>
          These packages will be installed in the Docker container running the R script.
          Do not forget to load them using <code>library()</code>.
        </p>
        <div className="form-group">
          <Select
            name="requires"
            value={this.props.packages.toArray()}
            multi="true"
            disabled={this.props.isSaving}
            allowCreate="true"
            delimiter=','
            onChange={this.handleValueChange}
            placeholder="Add packages..."
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
