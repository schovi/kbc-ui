import React, {PropTypes} from 'react';
import ConfirmButtons from '../../../../../react/common/ConfirmButtons';
import ItemsListEditor from '../../../../../react/common/ItemsListEditor';

export default React.createClass({
  propTypes: {
    packages: PropTypes.object.isRequired,
    isSaving: PropTypes.bool.isRequired,
    onChange: PropTypes.func.isRequired,
    onCancel: PropTypes.func.isRequired,
    onSave: PropTypes.func.isRequired
  },

  getInitialState() {
    return {
      input: ''
    };
  },

  render() {
    return (
      <div className="well">
        <p>
          These packages will be installed in the Docker container running the R script.
          Do not forget to load them using <code>library()</code>.
        </p>
        <div className="form-group">
          <ItemsListEditor
            value={this.props.packages}
            input={this.state.input}
            disabled={this.props.isSaving}
            onChangeValue={this.props.onChange}
            onChangeInput={this.handleInputChange}
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

  handleInputChange(newValue) {
    this.setState({
      input: newValue
    });
  }

});