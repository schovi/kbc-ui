import React, {PropTypes} from 'react/addons';
import {Modal} from 'react-bootstrap';
import ConfirmButtons from '../../../../react/common/ConfirmButtons';
import Select from 'react-select';

export default React.createClass({
  mixins: [React.addons.PureRenderMixin],
  propTypes: {
    tasks: PropTypes.object.isRequired,
    phases: PropTypes.object.isRequired,
    onMergePhases: React.PropTypes.func.isRequired,
    onHide: React.PropTypes.func.isRequired,
    show: React.PropTypes.bool.isRequired
  },

  getInitialState() {
    return {
      value: null
    };
  },


  isValid() {
    const val = this.state.value;
    return !!val;
  },

  render() {
    let formDivClass = 'form-group';
    return (
      <Modal
        show={this.props.show}
        onHide={this.props.onHide}
        title="Merge Selected Phases">
        <div className="modal-body">
          <div className="form form-horizontal">
            <div className={formDivClass}>
              <label htmlFor="title" className="col-sm-1 control-label">
                Into:
              </label>
              <div className="col-sm-11">
                <Select
                  placeholder="Select phase..."
                  clearable={false}
                  key="phases select"
                  name="phaseselector"
                  allowCreate={true}
                  value={this.state.value}
                  onChange= {(newValue) => this.setState({value: newValue})}
                  options= {this.getPhasesOptions()}
                />
                <span className="help-block">
                  Select a existing phase name or type new phase name.
                  </span>
              </div>
            </div>
          </div>
        </div>
        <div className="modal-footer">
          <ConfirmButtons
            saveLabel="Merge"
            isDisabled={!this.isValid()}
            onCancel={this.closeModal}
            onSave={this.handleSave}
          />
        </div>
      </Modal>
    );
  },

  getPhasesOptions() {
    const result = this.props.phases.map((key) => {
      return {
        'label': key,
        'value': key
      };
    }).toList().toJS();
    return result;
  },

  closeModal() {
    this.setState({
      value: null
    });
    this.props.onHide();
  },

  handleSave() {
    this.props.onMergePhases(this.state.value);
    this.setState({
      value: null
    });
  }

});
