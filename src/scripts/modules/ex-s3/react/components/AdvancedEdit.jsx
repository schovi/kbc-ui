import React, {PropTypes} from 'react';
import immutableMixin from '../../../../react/mixins/ImmutableRendererMixin';
import {Input} from 'react-bootstrap';

export default React.createClass({
  mixins: [immutableMixin],

  propTypes: {
    delimiter: PropTypes.string.isRequired,
    enclosure: PropTypes.string.isRequired,
    onChange: PropTypes.func.isRequired
  },

  onChangeDelimiter(e) {
    this.props.onChange('delimiter', e.target.value);
  },

  onChangeEnclosure(e) {
    this.props.onChange('enclosure', e.target.value);
  },

  render() {
    return (
      <div className="row form-horizontal">
        <div className="col-md-12">
          <Input
            type="text"
            label="Delimiter"
            labelClassName="col-xs-4"
            wrapperClassName="col-xs-8"
            value={this.props.delimiter}
            onChange={this.onChangeDelimiter}
            help={(<span>Field delimiter used in CSV file. Default value is <code>,</code>. Use <code>\t</code> for tabulator.</span>)}
            />
        </div>
        <div className="col-md-12">
          <Input
            type="text"
            label="Enclosure"
            labelClassName="col-xs-4"
            wrapperClassName="col-xs-8"
            value={this.props.enclosure}
            onChange={this.onChangeEnclosure}
            help={(<span>Field enclosure used in CSV file. Default value is <code>"</code>.</span>)}
            />
        </div>
      </div>
    );
  }
});
