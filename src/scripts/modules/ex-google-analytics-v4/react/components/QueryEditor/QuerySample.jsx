import React, {PropTypes} from 'react';
import {fromJS} from 'immutable';
import parse from '../../../../../utils/parseCsv';
import EmptyState from '../../../../components/react/components/ComponentEmptyState';
import {Table} from 'react-bootstrap';
import {Loader} from 'kbc-react-components';

export default React.createClass({
  propTypes: {
    query: PropTypes.object.isRequired,
    onRunQuery: PropTypes.func.isRequired
  },

  getInitialState: function() {
    return {
      isLoading: false,
      isError: false,
      error: null,
      data: []
    };
  },

  runQuery() {
    this.setState({
      isLoading: true
    });

    const component = this;

    this.props.onRunQuery(this.props.query)
      .then((result) => {
        console.log(result);
        console.log(result.status !== 'success');
        if (result.status !== 'success') {
          throw result;
        }
        return parse(result.data);
      })
      .then((data) => {
        component.setState({
          isLoading: false,
          isError: false,
          error: null,
          data: data
        });
      })
      .catch((error) => {
        component.setState({
          isLoading: false,
          isError: true,
          error: error,
          data: []
        });
      });
  },

  componentDidMount() {

  },

  render() {
    const csvMap = fromJS(this.state.data);

    if (csvMap.count() === 0 && csvMap !== null) {
      return (
        <div>
          {this.renderRunButton()}
          <EmptyState>
            No Data.
          </EmptyState>
        </div>
      );
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
      <div>
        {this.renderRunButton()}
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
      </div>
    );
  },

  renderRunButton() {
    return (
      <div>
        <button
          className="btn btn-primary"
          type="button"
          disabled={this.state.isLoading}
          onClick={() => {
            this.runQuery();
          }}
        >
          Run Query
        </button>
        {this.state.isLoading ? <Loader /> : null}
        {this.state.isError ? <div className="alert alert-danger">{this.state.error.message}</div> : null}
      </div>
    );
  }
});
