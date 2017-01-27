import React, {PropTypes} from 'react';
import {Map} from 'immutable';
import {Modal, Input} from 'react-bootstrap';
import ConfirmButtons from '../../../../react/common/ConfirmButtons';
import TemplateSelector from './TemplateSelector';
// import {Loader} from 'kbc-react-components';
// import SearchRow from '../../../../react/common/SearchRow';
// import {ListGroup, ListGroupItem} from 'react-bootstrap';

// import EmptyState from '../../../components/react/components/ComponentEmptyState';

export default React.createClass({

  propTypes: {
    accounts: PropTypes.object.isRequired,
    queryTemplates: PropTypes.object.isRequired,
    syncAccounts: PropTypes.object.isRequired,
    show: PropTypes.bool.isRequired,
    isSavingFn: PropTypes.func.isRequired,
    onHideFn: PropTypes.func,
    authorizedDescription: PropTypes.string,
    localState: PropTypes.object.isRequired,
    updateLocalState: PropTypes.func.isRequired,
    prepareLocalState: PropTypes.func.isRequired,
    onSaveQuery: PropTypes.func.isRequired
  },

  render() {
    return (
      <Modal
        bsSize="medium"
        show={this.props.show}
        onHide={this.props.onHideFn}
      >
        <Modal.Header closeButton>
          <Modal.Title>
            New Query
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <div className="form-horizontal clearfix">
            {this.renderHelpRow()}
            {this.renderInput('Name', 'name')}
            {this.renderInput('Endpoint', ['query', 'path'])}
            {this.renderFieldsInput()}
            {this.renderAccountSelector()}
            {this.renderAdvancedPart()}
          </div>
        </Modal.Body>
        <Modal.Footer>
          <ConfirmButtons
            isSaving={this.props.isSavingFn(this.query('id'))}
            onSave={this.handleSave}
            onCancel={this.props.onHideFn}
            placement="right"
            saveLabel="Save Changes"
            isDisabled={this.query(null, Map()).equals(this.localState('currentQuery'))}
          />
        </Modal.Footer>
      </Modal>
    );
  },

  renderAdvancedPart() {
    const showAdvanced = this.localState('showAdvanced', false);
    const clName = 'form-control';
    const sinceControl = this.renderInputControl(['query', 'since'], clName);
    const untilControl = this.renderInputControl(['query', 'until'], clName);
    const limitControl = this.renderInputControl(['query', 'limit'], clName);

    const result = (
      <div className="form-group">
        <div className="col-xs-12 checkbox" >
          <label>
            <input
              checked={showAdvanced}
              type="checkbox"
              onChange={() => this.updateLocalState('showAdvanced', !showAdvanced)}/>
            Advanced
          </label>
        </div>
        {showAdvanced ?
         <span>
           <label className="col-xs-offset-2 col-xs-1 control-label">
             Since
           </label>
           <div className="col-xs-4">
             {sinceControl}
           </div>
           <label className="col-xs-1 control-label">
             Until
           </label>
           <div className="col-xs-4">
             {untilControl}
           </div>
           <label style={{'padding-top': '20px'}}
             className="col-xs-offset-2 col-xs-1 control-label">
             Limit
           </label>
           <div style={{'padding-top': '10px'}}
             className="col-xs-4">
             {limitControl}
           </div>
         </span>
         : null}
      </div>);
    return result;
  },

  renderHelpRow() {
    const templateSelector = (
      <TemplateSelector
        templates={this.props.queryTemplates}
        query={this.query()}
        updateQueryFn={(query) => this.updateLocalState(['query'], query)}
      />
    );
    return this.renderFormControl('', templateSelector);
  },

  renderFieldsInput() {
    const control = (<textarea
                       value={this.query(['query', 'fields'])}
                       onChange={(e) => this.updateLocalState(['query', 'query', 'fields'], e.target.value)}
                       className="form-control" rows="6" required/>);
    return this.renderFormControl('Parameters', control);
  },

  renderInputControl(propertyPath, className = 'form-control') {
    return (
      <input
        type="text"
        value={this.query(propertyPath)}
        onChange={(e) => this.updateLocalState(['query'].concat(propertyPath), e.target.value)}
        className={className}
      />
    );
  },

  renderInput(caption, propertyPath) {
    const inputControl = this.renderInputControl(propertyPath);
    return this.renderFormControl(caption, inputControl);
  },

  renderFormControl(controlLabel, control) {
    return (
      <div className="form-group">
        <label className="col-xs-2 control-label">
          {controlLabel}
        </label>
        <div className="col-xs-10">
          {control}
        </div>
      </div>
    );
  },

  renderAccountSelector() {
    const hasIds = this.query('query', Map()).has('ids');
    const ids = this.query(['query', 'ids'], '');
    const value = hasIds ? ids : '--no-page--';
    return (
      <Input
        type="select"
        value={value}
        label="Pages"
        labelClassName="col-xs-2"
        wrapperClassName="col-xs-10"
        onChange={this.onSelectAccount}>
        <option value="">
          --all pages--
        </option>
        <option value="--no-page--">
          --no page--
        </option>
        {this.renderAccountsOptionsArray()}
      </Input>
    );
  },

  onSelectAccount(event) {
    const value = event.target.value;
    const query = this.query('query');
    if (value === '--no-page--') {
      this.updateLocalState(['query', 'query'], query.delete('ids'));
    } else {
      this.updateLocalState(['query', 'query'], query.set('ids', value));
    }
  },

  renderAccountsOptionsArray() {
    return this.props.accounts.map((account, accountId) =>
      <option value={accountId}>
        {account.get('name')}
      </option>
    );
  },

  localState(path, defaultVal) {
    return this.props.localState.getIn([].concat(path), defaultVal);
  },

  query(path, defaultValue) {
    if (path) {
      return this.localState(['query'].concat(path), defaultValue);
    } else {
      return this.localState(['query'], defaultValue);
    }
  },

  updateLocalState(path, newValue) {
    return this.props.updateLocalState([].concat(path), newValue);
  },

  handleSave() {
    this.props.onSaveQuery(this.query()).then(
      () => this.props.onHideFn());
  }

});
