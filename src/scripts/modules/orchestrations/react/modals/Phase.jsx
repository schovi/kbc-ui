import React, {PropTypes} from 'react/addons';
import {Modal} from 'react-bootstrap';
import ConfirmButtons from '../../../../react/common/ConfirmButtons';

export default React.createClass({
  mixins: [React.addons.PureRenderMixin],
  propTypes: {
    task: PropTypes.object.isRequired,
    onPhaseUpdate: React.PropTypes.func.isRequired
  },

  getInitialState() {
    return {
      phase: this.props.task.get('phase')
    };
  },

  render() {
    return (
      <Modal {...this.props} title="Task Phase">
        <div className="modal-body">
          <div className="form-horizontal">
            <div className="form-group">
              <div className="col-sm-offset-1 col-sm-9">
                <p>
                  Phase is a set of orchestration tasks.
                </p>
                <p className="help-block">
                  Adjacent tasks with the same phase number are run in parallel. Tasks with phase `null` will run isolated.
                </p>
                <p>
                  Phase # <input
                    type="number"
                    className="form-control"
                    value={parseInt(this.state.phase)}
                    onChange={this.handlePhaseChange}
                    style={{width: '50px', display: 'inline-block'}}
                    />
                </p>
              </div>
            </div>
          </div>
        </div>
        <div className="modal-footer">
          <ConfirmButtons
            saveLabel='Ok'
            onCancel={this.props.onRequestHide}
            onSave={this.handleSave}
            />
        </div>
      </Modal>
    );
  },

  handlePhaseChange(e) {
    if (e.target.value < 0) {
      return;
    }
    this.setState({
      phase: e.target.value
    });
  },

  handleSave() {
    this.props.onRequestHide();
    return this.props.onPhaseUpdate(this.props.task.set('phase', this.state.phase));
  }

});