import React, {PropTypes} from 'react';
// import EmptyState from '../../../../components/react/components/ComponentEmptyState';
import {Table} from 'react-bootstrap';
import {Loader} from 'kbc-react-components';

export default React.createClass({
  propTypes: {
    sampleDataInfo: PropTypes.object.isRequired,
    onRunQuery: PropTypes.func.isRequired,
    isQueryValid: PropTypes.bool
  },

  getSampleDataInfo(key, defaultValue) {
    return this.props.sampleDataInfo.getIn([].concat(key), defaultValue);
  },

  render() {
    return (
      <div>
        {this.renderRunButton()}
        {this.renderSamplesTable()}
      </div>
    );
  },

  renderSamplesTable() {
    const csvMap = this.getSampleDataInfo('data', null);
    if (!csvMap || csvMap.count() === 0 ) {
      return null;
    }
    const header = csvMap.first().map((c) => {
      return (
        <th>
          {c}
        </th>
      );
    }).toArray();

    const rows = csvMap.rest().map((row) => {
      const cols = row.map( (c) => {
        return (<td>{c}</td>);
      });

      return (
        <tr>
          {cols}
        </tr>);
    });
    return (
      <Table responsive className="table table-striped">
        <thead>
          <tr>
            {header}
          </tr>
        </thead>
        <tbody>
          {rows}
        </tbody>
      </Table>
    );
  },

  renderError(error) {
    console.log(error.toJS());
    let message = error.get('message');
    const code = error.get('code');
    if (code < 500) {
      try {
        message = JSON.parse(message).message || message;
      } catch (e) {
        message = message;
      }
    }
    return (
      <div className="alert alert-danger">
        {message}
        <div>
          {code >= 500 ? error.get('exceptionId') : null}
        </div>
      </div>
    );
  },

  renderRunButton() {
    const isLoading = this.getSampleDataInfo('isLoading', false);
    const isError = this.getSampleDataInfo('isError', false);
    const error = this.getSampleDataInfo('error');

    return (
      <div className="text-center">
        <button
          className="btn btn-primary"
          type="button"
          disabled={isLoading || !this.props.isQueryValid}
          onClick={this.props.onRunQuery}
        >
          Run Sample Query
          {isLoading ? <Loader /> : null}
        </button>
        {isError ?
         this.renderError(error)
         : null}
      </div>
    );
  }
});