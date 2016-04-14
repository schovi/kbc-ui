import React, {PropTypes} from 'react';
import {Input} from 'react-bootstrap';
export default React.createClass({
  propTypes: {
    mapping: PropTypes.object.isRequired,
    disabled: PropTypes.bool.isRequired,
    onChange: PropTypes.func.isRequired,
    labelClassName: PropTypes.string,
    wrapperClassName: PropTypes.string
  },

  getDefaultProps() {
    return {
      labelClassName: 'col-xs-2',
      wrapperClassName: 'col-xs-5'
    };
  },

  render() {
    return (
      <Input
        bsSize="small"
        type="number"
        label="Days"
        value={this.props.mapping.get('days')}
        disabled={this.props.disabled}
        placeholder={0}
        help={<small>Data updated in the given period</small>}
        onChange={this._handleChangeDays}
        labelClassName={this.props.labelClassName}
        wrapperClassName={this.props.wrapperClassName}

      />
    );
  },

  _handleChangeDays(e) {
    const value = this.props.mapping.set('days', parseInt(e.target.value, 10));
    this.props.onChange(value);
  }


});
