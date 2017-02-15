import React, {PropTypes} from 'react';
import {Map} from 'immutable';
import ConfirmButtons from '../../../../react/common/ConfirmButtons';
import TemplateSelector from './TemplateSelector';
import {Modal, OverlayTrigger, Tooltip, TabbedArea, TabPane} from 'react-bootstrap';
// import Select from 'react-select';
import Select from '../../../../react/common/Select';

const NAME_HELP = 'Helps describing the query and also used to prefix output tables name resulting from the query if they differ.';
const ENDPOINT_HELP = 'Url part of Facebook Graph API request specifying node-id and/or edge-name, e.g. feed, me/photos etc. Can be empty.';
const FIELDS_HELP = 'Parameter of Facebook Graph API nested request specifying fields and/or additional parameters of the endpoint.';
const SINCE_HELP = 'Parameter of Facebook Graph API nested request. Applies only if endpoint parameter is given and specifies the date since data of the given endpoint will be retrieved. Can by specified absolutely(yyyy-mm-dd) or relatively(e.g. 15 days ago)';
const UNTIL_HELP = 'Parameter of Facebook Graph API nested request. Applies only if endpoint parameter is given and specifies the date until data of the given endpoint will be retrieved. Can by specified absolutely(yyyy-mm-dd) or relatively(e.g. 15 days ago)';
const LIMIT_HELP = 'Parameter of Facebook Graph API nested request. Specifies size of data returned in one page of the request. Maximum is 100, default 25.';

export default React.createClass({

  propTypes: {
    accounts: PropTypes.object.isRequired,
    placeholders: PropTypes.object.isRequired,
    queryTemplates: PropTypes.object.isRequired,
    syncAccounts: PropTypes.object.isRequired,
    show: PropTypes.bool.isRequired,
    isSavingFn: PropTypes.func.isRequired,
    onHideFn: PropTypes.func,
    authorizedDescription: PropTypes.string,
    localState: PropTypes.object.isRequired,
    updateLocalState: PropTypes.func.isRequired,
    accountDescFn: PropTypes.func.isRequired,
    prepareLocalState: PropTypes.func.isRequired,
    onSaveQuery: PropTypes.func.isRequired
  },

  render() {
    const placeholders = this.props.placeholders || {};
    return (
      <Modal
        bsSize="large"
        show={this.props.show}
        onHide={this.props.onHideFn}
      >
        <Modal.Header closeButton>
          <Modal.Title>
            {this.localState(['currentQuery', 'name'], false) ? 'Edit' : 'New'} Query
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          {this.renderTemplateSelect()}
          <TabbedArea defaultActiveEventKey={1} animation={false}>
            <TabPane tab="General" eventKey={1}>
              <div className="row form-horizontal clearfix">
                  {this.renderInput('Name', 'name', NAME_HELP, placeholders.name, this.nameInvalidReason)}
                  {this.renderInput('Endpoint', ['query', 'path'], ENDPOINT_HELP, placeholders.path)}
                  {this.renderFieldsInput(placeholders.fields)}
                  {this.renderAccountSelector()}
              </div>
            </TabPane>
            <TabPane tab="Advanced" eventKey={2}>
              <div className="row form-horizontal clearfix">
                {this.renderInput('Since', ['query', 'since'], SINCE_HELP, 'yyyy-mm-dd or 15 days ago')}
                {this.renderInput('Until', ['query', 'until'], UNTIL_HELP, 'yyyy-mm-dd or 15 days ago')}
                {this.renderInput('Limit', ['query', 'limit'], LIMIT_HELP, '25')}
              </div>
            </TabPane>
          </TabbedArea>
        </Modal.Body>
        <Modal.Footer>
          <ConfirmButtons
            isSaving={this.props.isSavingFn(this.query('id'))}
            onSave={this.handleSave}
            onCancel={this.props.onHideFn}
            placement="right"
            saveLabel="Save Query"
            isDisabled={this.isSavingDisabled()}
          />
        </Modal.Footer>
      </Modal>
    );
  },

  nameInvalidReason() {
    const name = this.query('name');
    if (name && !(/^[a-zA-Z0-9-_]+$/.test(name))) return 'Can only contain alphanumeric characters, underscore and dot.';
    return null;
  },

  isSavingDisabled() {
    const queryHasChanged = !this.query(null, Map()).equals(this.localState('currentQuery'));
    const fieldsValid = !!this.query(['query', 'fields']);
    const nameEmpty = !!this.query(['name']);
    const limitEmpty = !!this.query(['query', 'limit']);
    return !queryHasChanged || !fieldsValid || !nameEmpty || !limitEmpty || this.nameInvalidReason();
  },

  renderTemplateSelect() {
    const templateSelector = (
      <div className="pull-right">
        <TemplateSelector
          templates={this.props.queryTemplates}
          query={this.query()}
          updateQueryFn={(query) => this.updateLocalState(['query'], query)}
        />
      </div>
    );
    return templateSelector;
  },

  renderFieldsInput(placeholder) {
    const control = (<textarea
                       placeholder={placeholder}
                       value={this.query(['query', 'fields'])}
                       onChange={(e) => this.updateLocalState(['query', 'query', 'fields'], e.target.value)}
                       className="form-control" rows="2" required/>);
    return this.renderFormControl('Fields', control, FIELDS_HELP);
  },

  renderInputControl(propertyPath, placeholder) {
    return (
      <input
        placeholder={placeholder}
        type="text"
        value={this.query(propertyPath)}
        onChange={(e) => this.updateLocalState(['query'].concat(propertyPath), e.target.value)}
        className="form-control"
      />
    );
  },

  renderInput(caption, propertyPath, helpText, placeholder, validationFn = () => null) {
    const validationText = validationFn();
    const inputControl = this.renderInputControl(propertyPath, placeholder);
    return this.renderFormControl(caption, inputControl, helpText, validationText);
  },

  renderFormControl(controlLabel, control, helpText, errorMsg) {
    return (
      <div className={errorMsg ? 'form-group has-error' : 'form-group'}>
        <label className="col-xs-2 control-label">
          {controlLabel}
        </label>
        <div className="col-xs-10">
          {control}
          <span className="help-block">
            {errorMsg || helpText}
          </span>
        </div>
      </div>
    );
  },

  renderTooltipHelp(message) {
    if (!message) return null;
    return (
      <small>
        <OverlayTrigger placement="right" overlay={<Tooltip>{message}</Tooltip>}>
          <i className="fa fa-fw fa-question-circle"/>
        </OverlayTrigger>
      </small>
    );
  },

  renderAccountSelector() {
    const hasIds = this.query('query', Map()).has('ids');
    const ids = this.query(['query', 'ids'], '');
    let value = hasIds ? ids : '--non--';
    if (!value) value = '--all--';
    const basicOptions = [
      {value: '--all--', label: `All ${this.props.accountDescFn('Pages')}`},
      {value: '--non--', label: 'None'}
    ];
    const restOptions = this.props.accounts.map((account, accountId) => {
      return {value: accountId, label: account.get('name')};
    }).toArray();
    const selectOptions = basicOptions.concat(restOptions);
    const selectControl = (
      <Select
        name="ids"
        key="ids"
        clearable={false}
        multi={false}
        allowCreate={false}
        emptyStrings={false}
        options={selectOptions}
        value={value}
        onChange={this.onSelectAccount}/>
    );
    const descFn = this.props.accountDescFn;
    const accountsHelp = `Specifies ${descFn('page')} that will be applied to the query. Could be either none, all or one of the selected ${descFn('pages')}. It is represented by Facebook Graph API nested request parameter ids.`;
    return this.renderFormControl(this.props.accountDescFn('Pages'), selectControl, accountsHelp);
  },

  onSelectAccount(value) {
    const query = this.query('query');
    switch (value) {
      case '--non--':
        return this.updateLocalState(['query', 'query'], query.delete('ids'));
      case '--all--':
        return this.updateLocalState(['query', 'query'], query.set('ids', ''));
      default:
        return this.updateLocalState(['query', 'query'], query.set('ids', value));
    }
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
