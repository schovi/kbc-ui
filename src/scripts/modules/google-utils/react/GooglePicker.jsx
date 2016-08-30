import React from 'react';
import _ from 'underscore';
import {Button} from 'react-bootstrap';
import * as InitGoogleApis from './InitGoogleApis';
const {apiKey, authorize, injectGapiScript} = InitGoogleApis;
import templates from './PickerViewTemplates';
import {GapiStore} from './GapiFlux';
import createStoreMixin from '../../../react/mixins/createStoreMixin';


const GDRIVE_SCOPE = [
  'https://www.googleapis.com/auth/drive.readonly'
];

const SHEETS_SCOPE = [
  'https://www.googleapis.com/auth/drive.readonly',
  'https://www.googleapis.com/auth/spreadsheets.readonly'
];


function setZIndex() {
  const elements = document.getElementsByClassName('picker');

  for (let i = 0; i < elements.length; i++) {
    const el = elements.item(i);
    el.style.zIndex = '1500';
  }
}

const authorizePicker = (userEmail, scope, callbackFn) => {
  return authorize(scope, callbackFn, userEmail);
};

const createGdrivePicker = (viewsParam, viewGroups) => {
  let picker = new window.google.picker.PickerBuilder()
    .setDeveloperKey(apiKey)
    .enableFeature(window.google.picker.Feature.MULTISELECT_ENABLED);
  //  .setOrigin($scope.origin)
  let views = viewsParam;
  if (_.isEmpty(views)) views = [templates.root];

  for (let group of viewGroups) {
    picker = picker.addViewGroup(group());
  }
  for (let view of views) {
    picker = picker.addView(view());
  }
  // picker.A.style.zIndex = 2000
  return picker;
};

export default React.createClass({

  displayName: 'googlePicker',
  mixins: [createStoreMixin(GapiStore)],
  propTypes: {
    dialogTitle: React.PropTypes.string.isRequired,
    buttonLabel: React.PropTypes.string.isRequired,
    onPickedFn: React.PropTypes.func.isRequired,
    views: React.PropTypes.array,
    viewGroups: React.PropTypes.array,
    email: React.PropTypes.string,
    buttonProps: React.PropTypes.object,
    requireSheetsApi: React.PropTypes.bool
  },

  getStateFromStores() {
    return {isInitialized: GapiStore.isInitialized()};
  },

  componentDidMount() {
    return injectGapiScript();
  },

  render() {
    let buttonProps = {className: 'btn btn-success'};
    if (this.props.buttonProps) buttonProps = this.props.buttonProps;
    buttonProps.onClick = this._ButtonClick;
    buttonProps.disabled = !this.state.isInitialized;
    return (
      <Button {...buttonProps}>
        {this.props.buttonLabel}
      </Button>
    );
  },

  getDefaultProps() {
    return {
      dialogTitle: 'Choose',
      buttonLabel: 'Choose',
      views: [],
      requireSheetsApi: false
    };
  },


  getInitialState() {
    return {accessToken: null};
  },

  _ButtonClick() {
    let scope = GDRIVE_SCOPE;
    if (this.props.requireSheetsApi) scope = SHEETS_SCOPE;
    if (!this.state.accessToken) {
      authorizePicker(this.props.email, scope, (authResult) => {
        if (authResult && !authResult.error) {
          this.setState({accessToken: authResult.access_token});
          this._doOpenGdrivePicker();
        }
      });
    } else { // already authorized
      this._doOpenGdrivePicker();
    }
  },

  _doOpenGdrivePicker() {
    let picker = createGdrivePicker(this.props.views, this.props.viewGroups || []);
    picker = picker.setTitle(this.props.dialogTitle)
      .setCallback(this._onPicked)
      .setOAuthToken(this.state.accessToken);
    picker.build().setVisible(true);
    setZIndex();
  },

  _onPicked(data) {
    if (data.action !== 'picked') return;
    this.props.onPickedFn(data.docs);
    return;
  }
});
