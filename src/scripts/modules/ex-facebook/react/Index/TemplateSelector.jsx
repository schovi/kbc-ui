import React, {PropTypes} from 'react';
// import {Map} from 'immutable';

export default React.createClass({
  propTypes: {
    templates: PropTypes.object.isRequired,
    query: PropTypes.object.isRequired,
    updateQueryFn: PropTypes.func.isRequired
  },

  render() {
    return (
      <select
        onChange={this.selectTemplate}
        className="form-control">
        <option value="" disabled={true} selected="selected">
          Select from a template
        </option>
        {this.props.templates.map((t) =>
          <option value={t.get('id')} >
            {t.get('name')}
          </option>
         ).toArray()}
      </select>
    );
  },

  selectTemplate(e) {
    const id = e.target.value;
    const optionValue = this.props.templates.findLast((t) => t.get('id') === id);
    const templateQuery = optionValue.get('template');
    const newQuery = this.props.query.mergeDeep(templateQuery);
    this.props.updateQueryFn(newQuery);
  }
});
