import React, {PropTypes} from 'react';
import HeaderColumnsMultiSelect from './HeaderColumnsMultiSelect';

export default React.createClass({

  propTypes: {
    headerRowValue: PropTypes.number.isRequired,
    onChangeHeaderRow: PropTypes.func.isRequired,

    headerColumnNamesValue: PropTypes.object.isRequired,
    onChangeHeaderColumnNames: PropTypes.func.isRequired,

    transposeHeaderRowValue: PropTypes.number.isRequired,
    onChangeTransposeHeaderRow: PropTypes.func.isRequired,

    transposedHeaderColumnNameValue: PropTypes.string.isRequired,
    onChangeTransposedHeaderColumnName: PropTypes.func.isRequired,

    transposeFromValue: PropTypes.number.isRequired,
    onChangeTransposeFrom: PropTypes.func.isRequired
  },

  render() {
    return (
      <div className="processorControls col-md-12">
        {this.renderInput(
          'number',
          'Number of header rows',
          this.props.headerRowValue,
          this.props.onChangeHeaderRow
        )}

        <div className="form-group">
          <label className="control-label col-sm-4">
            Header column names <br /> (Overrides header)
          </label>
          <div className="col-sm-4">
            <HeaderColumnsMultiSelect
              value={this.props.headerColumnNamesValue}
              onChange={this.props.onChangeHeaderColumnNames}
            />
          </div>
        </div>

        {this.renderInput(
          'number',
          'Transpose header row number',
          this.props.transposeHeaderRowValue,
          this.props.onChangeTransposeHeaderRow
        )}

        {this.renderInput(
          'text',
          'Transposed header column name',
          this.props.transposedHeaderColumnNameValue,
          this.props.onChangeTransposedHeaderColumnName
        )}

        {this.renderInput(
          'number',
          'Transpose from column',
          this.props.transposeFromValue,
          this.props.onChangeTransposeFrom
        )}
      </div>
    );
  },

  renderInput(type, name, value, onChangeFn) {
    return (
      <div className="form-group">
        <label className="control-label col-sm-4">
          {name}
        </label>
        <div className="col-sm-2">
          <div className="input-group">
            <input
              onChange={onChangeFn}
              value={value}
              type={type}
              className="form-control form-control-sm"
              />
          </div>
        </div>
      </div>
    );
  }
});
