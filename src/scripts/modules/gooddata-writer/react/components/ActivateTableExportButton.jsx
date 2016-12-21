import React from 'react';
import ActivateDeactivateButton from '../../../../react/common/ActivateDeactivateButton';
import actionCreators from '../../actionCreators';

export default React.createClass({
  propTypes: {
    configId: React.PropTypes.string.isRequired,
    table: React.PropTypes.object.isRequired,
    tooltipPlacement: React.PropTypes.string.isRequired
  },

  getDefaultProps() {
    return { tooltipPlacement: 'top' };
  },

  render() {
    return (
      <ActivateDeactivateButton
        activateTooltip="Add table to project upload"
        deactivateTooltip="Remove table from the project upload"
        isActive={this.props.table.getIn(['data', 'export'])}
        isPending={this.props.table.get('savingFields').contains('export')}
        onChange={this.handleExportChange}
        tooltipPlacement={this.props.tooltipPlacement}
      />
    );
  },

  handleExportChange(newExportStatus) {
    actionCreators.saveTableField(this.props.configId, this.props.table.get('id'), 'export', newExportStatus);
  }

});
