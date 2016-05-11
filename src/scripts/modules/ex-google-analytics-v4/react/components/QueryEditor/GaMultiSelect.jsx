import React, {PropTypes} from 'react';
import {Loader} from 'kbc-react-components';
import fuzzy from 'fuzzy';
import Select from 'react-select';
import Tooltip from '../../../../../react/common/Tooltip';

import './GaMultiSelect.less';

export default React.createClass({
  propTypes: {
    selectedValues: PropTypes.object.isRequired,
    onSelectValue: PropTypes.func.isRequired,
    name: PropTypes.string.isRequired,
    isGaInitialized: PropTypes.bool.isRequired,
    isEditing: PropTypes.bool.isRequired,
    isLoadingMetadata: PropTypes.bool.isRequired,
    metadata: PropTypes.array.isRequired,

    labelClassName: PropTypes.string,
    wrapperClassName: PropTypes.string

  },

  getDefaultProps() {
    return {
      labelClassName: 'col-md-12 control-label',
      wrapperClassName: 'col-md-10'
    };
  },

  filterOption(op, filter) {
    const isNew = op.create;
    const data = {
      group: isNew ? '' : op.attributes.group,
      name: isNew ? op.value : op.attributes.uiName,
      desc: isNew ? '' : op.attributes.description,
      id: isNew ? op.value : op.id

    };

    return !!fuzzy.match(filter, data.group) ||
           !!fuzzy.match(filter, data.name) ||
           !!fuzzy.match(filter, data.id) ||
           data.desc.search(filter) >= 0;
  },

  createNewOption(input) {
    const found = this.props.metadata.find((m) => m.id === input);
    if (found) {
      return found;
    } else {
      return {
        create: true,
        value: input,
        label: input
      };
    }
  },

  renderOption(op) {
    const isNew = op.create;

    const data = {
      group: isNew ? 'N/A' : op.attributes.group,
      name: isNew ? op.value : op.attributes.uiName,
      desc: isNew ? '' : op.attributes.description,
      id: isNew ? op.value : op.id
    };

    return (
      <div className="SearchSuggestMatch" key={data.id}>
        <span className="SearchSuggestMatch-category">{data.group}</span>
        <div className="SearchSuggestMatch-content">{data.id} ({data.name})</div>
        <div className="SearchSuggestMatch-extra">{data.desc}</div>
      </div>
    );
  },


  renderValue(op) {
    // console.log('render value', op);
    return op.id || op.value;
  },

  prepareOptionsData(data) {
    return data.map((op) => {
      op.value = op.id;
      return op;
    })
               .sort((a, b) => a.attributes.group.localeCompare(b.attributes.group));
    // .filter((op) => this.props.selectedValues.indexOf(op.value) < 0);
  },


  render() {
    if (!this.props.isGaInitialized) {
      return <Loader />;
    }

    if (!this.props.isEditing) {
      return this.renderStatic();
    }

    return (
      <div className="form-group">
        <label className={this.props.labelClassName}>
          {this.props.name}
        </label>
        <div className={this.props.wrapperClassName}>
          <Select
            multi={true}
            isLoading={this.props.isLoadingMetadata}
            allowCreate={true}
            value={this.props.selectedValues}
            filterOption={this.filterOption}
            optionRenderer={this.renderOption}
            valueRenderer={this.renderValue}
            options={this.prepareOptionsData(this.props.metadata)}
            onChange={this.props.onSelectValue}
            newOptionCreator={this.createNewOption}
            name={name} />
        </div>
      </div>
    );
  },

  renderStatic() {
    return (
      <div className="form-group">
        <label className={'control-label ' + this.props.labelClassName}>
          {this.props.name}
        </label>
        <div className={this.props.wrapperClassName}>
          <p className="form-control-static">
            {this.props.selectedValues.map((val, idx) => this.renderStaticOption(val, idx))}
          </p>
        </div>
      </div>
    );
  },

  renderStaticOption(optionId, idx) {
    const option = this.props.metadata.find((op) => op.id === optionId);
    const desc = option ? option.attributes.description : '';
    const name = option ? option.attributes.uiName : '';
    const isLast = idx === this.props.selectedValues.length - 1;
    return (
      <span>
        <Tooltip tooltip={desc} placement="top">
          <span>
            {optionId}({name})
          </span>
        </Tooltip>
        {isLast ? '' : ', '}
      </span>
    );
  }
});
