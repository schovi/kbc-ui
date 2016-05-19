import React from 'react';
import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import immutableMixin from '../../../../react/mixins/ImmutableRendererMixin';
import TransformationsStore from '../../stores/TransformationsStore';
import ActionCreators from '../../ActionCreators';
import InlineEditTextInput from '../../../../react/common/InlineEditTextInput';

module.exports = React.createClass({
  displayName: 'ComponentRowEditField',
  mixins: [createStoreMixin(TransformationsStore), immutableMixin],

  propTypes: {
    configId: React.PropTypes.string.isRequired,
    rowId: React.PropTypes.string.isRequired,
    placeholder: React.PropTypes.string,
    tooltipPlacement: React.PropTypes.string
  },

  getDefaultProps: function() {
    return {
      placeholder: 'Name the transformation...',
      tooltipPlacement: 'bottom'
    };
  },

  componentWillReceiveProps: function(nextProps) {
    return this.setState(this.getState(nextProps));
  },

  getStateFromStores: function() {
    return this.getState(this.props);
  },

  getState: function(props) {
    return {
      value: TransformationsStore.getTransformation(props.configId, props.rowId).get('name'),
      editValue: TransformationsStore.getTransformationEditingFields(props.configId, props.rowId).get('name'),
      isEditing: TransformationsStore.getTransformationEditingFields(props.configId, props.rowId).has('name'),
      isSaving: TransformationsStore.getTransformationPendingActions(props.configId, props.rowId).has('save-name'),
      isValid: TransformationsStore.getTransformationEditingFields(props.configId, props.rowId).get('name', '') !== ''
    };
  },

  _handleEditStart: function() {
    return ActionCreators.startTransformationFieldEdit(this.props.configId, this.props.rowId, 'name');
  },

  _handleEditCancel: function() {
    return ActionCreators.cancelTransformationEditingField(this.props.configId, this.props.rowId, 'name');
  },

  _handleEditChange: function(newValue) {
    return ActionCreators.updateTransformationEditingField(this.props.configId, this.props.rowId, 'name', newValue);
  },

  _handleEditSubmit: function() {
    const changeDescription = this.state.value + ' changed to ' + this.state.editValue;
    return ActionCreators.changeTransformationProperty(
      this.props.configId,
      this.props.rowId,
      'name',
      this.state.editValue,
      changeDescription
    );
  },

  render: function() {
    return (
      <InlineEditTextInput
        text={this.state.isEditing ? this.state.editValue : this.state.value}
        placeholder={this.props.placeholder}
        tooltipPlacement={this.props.tooltipPlacement}
        isSaving={this.state.isSaving}
        isEditing={this.state.isEditing}
        isValid={this.state.isValid}
        onEditStart={this._handleEditStart}
        onEditCancel={this._handleEditCancel}
        onEditChange={this._handleEditChange}
        onEditSubmit={this._handleEditSubmit}
        />
    );
  }
});
