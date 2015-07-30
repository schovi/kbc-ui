import React, {PropTypes} from 'react';
import Detail from './TableInputMappingDetail';
import Header from './TableInputMappingHeader';
import {Panel} from 'react-bootstrap';
import Immutable from 'immutable';
import InstalledComponentsActions from '../../../InstalledComponentsActionCreators';

export default React.createClass({
  propTypes: {
    componentId: PropTypes.string.isRequired,
    configId: PropTypes.string.isRequired,
    editingInput: PropTypes.object.isRequired,
    input: PropTypes.object.isRequired,
    tables: PropTypes.object.isRequired,
    pendingActions: PropTypes.object.isRequired,
    openMappings: PropTypes.object.isRequired
  },

  render() {
    return (
      <div>
        <h2>InputMapping</h2>
        {this.content()}
      </div>
    );
  },

  toggleMapping(key) {
    return InstalledComponentsActions.toggleMapping(this.props.componentId, this.props.configId, 'table-input-' + key);
  },

  onChangeMapping(key, value) {
    return InstalledComponentsActions.changeEditingMapping(this.props.componentId, this.props.configId, 'input', 'tables', key, value);
  },

  onEditStart(key) {
    return InstalledComponentsActions.startEditingMapping(this.props.componentId, this.props.configId, 'input', 'tables', key);
  },

  onSaveMapping(key) {
    return InstalledComponentsActions.saveEditingMapping(this.props.componentId, this.props.configId, 'input', 'tables', key);
  },

  onCancelEditMapping(key) {
    return InstalledComponentsActions.cancelEditingMapping(this.props.componentId, this.props.configId, 'input', 'tables', key);
  },

  onDeleteMapping(key) {
    return InstalledComponentsActions.deleteMapping(this.props.componentId, this.props.configId, 'input', 'tables', key);
  },

  content() {
    var component = this;
    if (this.props.input.count() >= 1) {
      var mappings = this.props.input.map(function(input, key) {
        return React.createElement(Panel,
          {
            className: 'kbc-panel-heading-with-table',
            key: key,
            collapsible: true,
            eventKey: key,
            expanded: component.props.openMappings.get('table-input-' + key, false),
            header: React.createElement('div',
              {
                onClick: function () {
                  component.toggleInputMapping(key);
                }
              }, React.createElement(Header,
                {
                  inputMapping: input,
                  editingInputMapping: component.props.editingInput.get(key, Immutable.Map()),
                  tables: component.props.tables,
                  mappingIndex: key,
                  pendingActions: component.props.pendingActions,
                  onEditStart: function() {
                    return component.onEditStart(key);
                  },
                  onChange: function(value) {
                    return component.onChangeMapping(key, value);
                  },
                  onSave: function() {
                    return component.onSaveMapping(key);
                  },
                  onCancel: function() {
                    return component.onCancelEditMapping(key);
                  },
                  onDelete: function() {
                    return component.onDeleteMapping(key);
                  }
                }))
          },
          React.createElement(Detail,
            {
              fill: true,
              inputMapping: input,
              tables: component.props.tables
            }
          )
        );
      }).toJS();
      return (
        <span>
          <div>Mappings</div>
          <code>{JSON.stringify(this.props.input.toJSON())}</code>
          {mappings}
        </span>
      );
    } else {
      return (
        <div className="well text-center">
          <p>No table input mapping assigned.</p>
        </div>
      );
    }
  }
});
