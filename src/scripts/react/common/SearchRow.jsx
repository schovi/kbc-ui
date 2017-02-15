import React from 'react';


export default React.createClass({

  propTypes: {
    query: React.PropTypes.string.isRequired,
    onChange: React.PropTypes.func,
    onSubmit: React.PropTypes.func,
    className: React.PropTypes.string
  },

  getInitialState() {
    return {
      query: this.props.query
    };
  },

  getDefaultProps() {
    return {
      onChange: () => {},
      onSubmit: (query) => query
    };
  },

  componentDidMount() {
    this.refs.searchInput.getDOMNode().focus();
  },

  onChange(event) {
    this.setState({
      query: event.target.value
    });
    this.props.onChange(event.target.value);
  },

  onSubmit(event) {
    event.preventDefault();
    this.props.onSubmit(this.state.query);
  },

  render() {
    return (
      <form className={'kbc-search ' + this.props.className} onSubmit={this.onSubmit}>
        <span className="kbc-icon-search" />
        <input
          type="text"
          value={this.state.query}
          className="form-control"
          placeholder="Search"
          ref="searchInput"
          onChange={this.onChange}
        />
      </form>
    );
  }

});
