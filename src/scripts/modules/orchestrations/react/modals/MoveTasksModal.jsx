import React, {PropTypes} from 'react/addons';
import {Modal} from 'react-bootstrap';
import ConfirmButtons from '../../../../react/common/ConfirmButtons';
import Select from 'react-select';

export default React.createClass({
  mixins: [React.addons.PureRenderMixin],
  propTypes: {
    phases: PropTypes.object.isRequired,
    onMoveTasks: React.PropTypes.func.isRequired,
    onHide: React.PropTypes.func.isRequired,
    show: React.PropTypes.bool.isRequired,
    title: React.PropTypes.string,
    ignorePhaseId: React.PropTypes.string
  },

  getInitialState() {
    return {
      value: null
    };
  },

  getDefaultProps() {
    return {
      title: 'Move Selected Tasks to Phase'
    };
  },

  render() {
    let formDivClass = 'form-group';
    return (
      <Modal
        show={this.props.show}
        onHide={this.props.onHide}
        title={this.props.title}>
        <div className="modal-body">
          <div className="form form-horizontal">
            <div className={formDivClass}>
              <label htmlFor="title" className="col-sm-1 control-label" />
              <div className="col-sm-11">
                <Select
                  placeholder="Select phase or type new..."
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
            saveLabel="Move"
            isDisabled={!this.isValid()}
            onCancel={this.closeModal}
            onSave={this.handleSave}
          />
        </div>
      </Modal>
    );
  },

  isValid() {
    return true;
  },

  getPhasesOptions() {
    const result = this.props.phases
                       .filter((pid) => pid !== this.props.ignorePhaseId)
                       .map((key) => {
                         return {
                           'label': key,
                           'value': key
                         };
                       }).toList().toJS();
    return result;
  },

  closeModal() {
    this.props.onHide();
  },

  handleSave() {
    this.props.onMoveTasks(this.state.value);
  }

});
