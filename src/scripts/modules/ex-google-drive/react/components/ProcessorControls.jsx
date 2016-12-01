import React, {PropTypes} from 'react';
import {fromJS, List} from 'immutable';
import HeaderColumnsMultiSelect from './HeaderColumnsMultiSelect';

export default React.createClass({

  propTypes: {
    localState: PropTypes.object.isRequired,
    updateLocalState: PropTypes.func.isRequired,
    prepareLocalState: PropTypes.func.isRequired
  },

  render() {
    return (
      <div className="processorControls">
      {this.renderInput(
        'number',
        'Number of header rows',
        this.headerRowValue(),
        this.onChangeHeaderRow
      )}

      <div className="form-group">
        <label className="control-label col-sm-4">
          Header column names <br /> (Overrides header)
        </label>
        <div className="col-sm-4">
          <HeaderColumnsMultiSelect
            value={this.headerColumnNamesValue()}
            onChange={this.onChangeHeaderColumnNames}
          />
        </div>
      </div>

      {this.renderInput(
        'number',
        'Transpose header row number',
        this.transposeHeaderRowValue(),
        this.onChangeTransposeHeaderRow
      )}

      {this.renderInput(
        'text',
        'Transposed header column name',
        this.transposedHeaderColumnNameValue(),
        this.onChangeTransposedHeaderColumnName
      )}

      {this.renderInput(
        'number',
        'Transpose from column',
        this.transposeFromValue(),
        this.onChangeTransposeFrom
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
  },

  headerRowValue() {
    const defaultValue = this.props.localState.getIn(['sheet', 'header', 'row'], 1);
    return this.props.localState.get('headerRow', defaultValue);
  },

  onChangeHeaderRow(e) {
    const newVal = parseInt(e.target.value, 10);
    this.props.updateLocalState('headerRow', newVal);
  },

  headerColumnNamesValue() {
    const defaultValue = this.props.localState.getIn(['sheet', 'processor', 'headerColumnNames'], List());
    const columnNames = this.props.localState.get('headerColumnNames', defaultValue);
    const columnNamesArr = columnNames.map((m) => m.get('name')).toArray();
    return columnNamesArr.length > 0 ? columnNamesArr : null;
  },

  onChangeHeaderColumnNames(strColumnNames) {
    let columnsArray = [];
    if (strColumnNames && strColumnNames !== '') {
      for ( let column of strColumnNames.split(',')) {
        if (columnsArray.indexOf(column) < 0) {
          columnsArray.push(column);
        }
      }
    }
    const newColumnNames = fromJS(columnsArray.map((m) => {return {name: m};}));
    this.props.updateLocalState('headerColumnNames', newColumnNames);
  },

  transposeHeaderRowValue() {
    const defaultValue = this.props.localState.getIn(['sheet', 'processor', 'transposeHeaderRow'], 0);
    return this.props.localState.get('transposeHeaderRow', defaultValue);
  },

  onChangeTransposeHeaderRow(e) {
    const maxVal = this.props.localState.get('headerRow', 1);
    const newVal = (e.target.value > maxVal) ? maxVal : e.target.value;
    this.props.updateLocalState('transposeHeaderRow', newVal);
  },

  transposedHeaderColumnNameValue() {
    const defaultValue = this.props.localState.getIn(['sheet', 'processor', 'transposedHeaderColumnName'], '');
    // console.log(this.props.localState.get('transposedHeaderColumnName', defaultValue).trim());
    return this.props.localState.get('transposedHeaderColumnName', defaultValue).trim();
  },

  onChangeTransposedHeaderColumnName(e) {
    const newVal = e.target.value;
    this.props.updateLocalState('transposedHeaderColumnName', newVal);
  },

  transposeFromValue() {
    const defaultValue = this.props.localState.getIn(['sheet', 'processor', 'transposeFrom'], 0);
    return this.props.localState.get('transposeFrom', defaultValue);
  },

  onChangeTransposeFrom(e) {
    const newVal = e.target.value;
    this.props.updateLocalState('transposeFrom', newVal);
  }

});
