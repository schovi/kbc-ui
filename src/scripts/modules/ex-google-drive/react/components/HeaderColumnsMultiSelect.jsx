import React, {PropTypes} from 'react';
import Select from 'react-select';

export default React.createClass({

  propTypes: {
    value: PropTypes.object.isRequired,
    onChange: PropTypes.func.isRequired
  },

  render() {
    return (
      <Select
        multi={true}
        isLoading={false}
        allowCreate={true}
        value={this.props.value}
        // valueRenderer={this.renderValue}
        // optionRenderer={this.renderOption}
        onChange={this.props.onChange}
        // newOptionCreator={this.createNewOption}
        name="headerColumnNames"
        placeholder="Type new values"
      />
    );
  },

  shouldComponentUpdate() {
    return false;
  },

  renderValue(op) {
    return op.id || op.value;
  },

  createNewOption(input) {
    return {
      create: true,
      value: input,
      label: input
    };
  },

  renderOption(op) {
    const isNew = op.create;

    const data = {
      name: isNew ? op.value : op.attributes.uiName,
      id: isNew ? op.value : op.id
    };

    return (
      <div className="SearchSuggestMatch" key={data.id}>
        <span className="SearchSuggestMatch-category">{data.group}</span>
        <div className="SearchSuggestMatch-content">{data.id} ({data.name || 'n/a'})</div>
        <div className="SearchSuggestMatch-extra">{data.desc}</div>
      </div>
    );
  }
});
