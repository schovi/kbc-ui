import React, {PropTypes} from 'react/addons';
import {Modal} from 'react-bootstrap';
import ConfirmButtons from '../../../../react/common/ConfirmButtons';
import actionCreators from '../../ActionCreators';

export default React.createClass({
  mixins: [React.addons.PureRenderMixin],
  propTypes: {
    transformation: PropTypes.object.isRequired,
    bucketId: PropTypes.string.isRequired
  },

  getInitialState() {
    return {
      isSaving: false,
      phase: this.props.transformation.get('phase')
    };
  },

  render() {
    return (
      <Modal {...this.props} title="Transformation Phase">
        <div className="modal-body">
          <div className="form-horizontal">
            <div className="form-group">
              <div className="col-sm-offset-1 col-sm-9">
                <p>
                  <a href="http://wiki.keboola.com/home/keboola-connection/devel-space/transformations/intro#Phases">Phase</a> is a set of transformations.
                </p>
                <p className="help-block">
                  Phases may be used to divide transformations into logical blocks, transfer data between transformations, transformation engines and remote transformations.
                </p>
                <p>
                  Phase # <input
                    type="number"
                    className="form-control"
                    value={parseInt(this.state.phase)}
                    onChange={this.handlePhaseChange}
                    disabled={this.state.isSaving}
                    style={{width: '50px', display: 'inline-block'}}
                    />
                </p>
              </div>
            </div>
          </div>
        </div>
        <div className="modal-footer">
          <ConfirmButtons
            isSaving={this.state.isSaving}
            onCancel={this.props.onRequestHide}
            onSave={this.handleSave}
            isDisabled={!this.isValid()}
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
    this.setState({
      isSaving: true
    });
    actionCreators
    .changeTransformationProperty(this.props.bucketId,
      this.props.transformation.get('id'),
      'phase',
      this.state.phase
    )
    .then(() => this.props.onRequestHide())
    .catch((e) => {
      this.setState({
        isSaving: false
      });
      throw e;
    });
  },

  isValid() {
    return this.state.phase >= 1;
  }

});