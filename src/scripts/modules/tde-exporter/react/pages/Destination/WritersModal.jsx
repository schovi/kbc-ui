import React, {PropTypes} from 'react';
import {Button, Modal, Input} from 'react-bootstrap';
import ComponentsStore from '../../../../components/stores/ComponentsStore';

export default React.createClass({

  propTypes: {
    localState: PropTypes.object.isRequired,
    setLocalState: PropTypes.func,
    onChangeWriterFn: PropTypes.func
  },

  getInitialState() {
    return {task: 'tableauServer'};
  },

  render() {
    return (
      <Modal show={this.props.localState.get('show', false)} onHide={this.close}>
        <Modal.Header>
          <Modal.Title> Choose Destination Type </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          {this.renderBody()}
        </Modal.Body>
        <Modal.Footer>
          <Button bsStyle="link" onClick={this.close}>Close</Button>
          <Button bsStyle= "primary" onClick={() => this.props.onChangeWriterFn(this.state.task)}>Change</Button>
        </Modal.Footer>
      </Modal>
    );
  },

  renderBody() {
    return (
      <div className="form form-horizontal">
        <p>Choose the destination writer type:</p>
        <Input
            type="select"
            wrapperClassName="col-sm-10"
            value={this.state.task}
            onChange={(e) => {
              this.setState({task: e.target.value});
            }
            } >
          {this.generateOption('wr-tableau-server', 'tableauServer')}
          {this.generateOption('wr-dropbox', 'dropbox')}
          {this.generateOption('wr-google-drive', 'gdrive')}
        </Input>
      </div>
    );
  },

  generateOption(componentId, taskName) {
    const component = ComponentsStore.getComponent(componentId);
    return (
      <option key={taskName} value={taskName}>
        {component.get('name')}
      </option>
    );
  },

  close() {
    this.props.setLocalState('show', false);
  }

});
