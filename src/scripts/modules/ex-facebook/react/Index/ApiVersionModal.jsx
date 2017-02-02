import React, {PropTypes} from 'react/addons';
import {Modal} from 'react-bootstrap';
import ConfirmButtons from '../../../../react/common/ConfirmButtons';

export default React.createClass({
  mixins: [React.addons.PureRenderMixin],
  propTypes: {
    onHide: React.PropTypes.func.isRequired,
    show: React.PropTypes.bool.isRequired,
    isSaving: React.PropTypes.bool.isRequired,
    localState: PropTypes.object.isRequired,
    onSave: PropTypes.func.isRequired,
    updateLocalState: PropTypes.func.isRequired,
    prepareLocalState: PropTypes.func.isRequired,
    currentVersion: PropTypes.string.isRequired,
    defaultVersion: PropTypes.string.isRequired
  },


  isValid() {
    return !!this.getVersion();
  },

  render() {
    const value = this.getVersion();

    return (
      <Modal
        show={this.props.show}
        onHide={this.props.onHide}
        title="Set Facebook API Version">
        <div className="modal-body">
          <div className="form form-horizontal">
            <div className="form-group">
              <div className="col-sm-offset-1 col-sm-9">
                <p>
                  Facebook has its own specific platform {' '}
                  <a
                    href="https://developers.facebook.com/docs/apps/versions"
                    target="_blank">versioning</a>. If you change the api version some api calls specified in queries may not work resulting in error, or no data as well as data with different columns might be retrieved. To review the api changes see <a href="https://developers.facebook.com/docs/apps/changelog" target="_blank"> changelog </a>. The most recent api version is {this.props.defaultVersion}.
                </p>
                <p>
                Api Version <input
                              id="version"
                              type="text"
                              className="form-control"
                              value={value}
                              onChange={this.handleVersionChange}
                              style={{width: '100px', display: 'inline-block'}}/>
                </p>
              </div>
            </div>
          </div>
        </div>
        <div className="modal-footer">
          <ConfirmButtons
            saveLabel="Change"
            isDisabled={!this.isValid() || this.props.currentVersion === this.getVersion()}
            onCancel={this.closeModal}
            onSave={this.handleSave}
            isSaving={this.props.isSaving}
          />
        </div>
      </Modal>
    );
  },

  getVersion() {
    return this.props.localState.get('version', '');
  },

  closeModal() {
    this.props.onHide();
  },

  handleSave() {
    this.props.onSave(this.getVersion()).then(() => this.props.onHide());
  },

  handleVersionChange(e) {
    const value = e.target.value;
    this.props.updateLocalState('version', value);
  }
});
