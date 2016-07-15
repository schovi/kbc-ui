import React, {PropTypes} from 'react';
import immutableMixin from '../../../../react/mixins/ImmutableRendererMixin';
import {Input} from 'react-bootstrap';

export default React.createClass({
  mixins: [immutableMixin],

  propTypes: {
    settings: PropTypes.object.isRequired,
    onChange: PropTypes.func.isRequired
  },

  onChangeDestination(e) {
    var settings = this.props.settings.set('destination', e.target.value);
    this.props.onChange(settings);
  },

  onChangeIncremental(e) {
    var settings = this.props.settings.set('incremental', e.target.value);
    this.props.onChange(settings);
  },


  render() {
    return (
      <div>
        <div className="row col-md-12">
          <Input
            type="text"
            label="Destination"
            labelClassName="col-xs-4"
            wrapperClassName="col-xs-8"
            value={this.props.settings.get('destination')}
            onChange={this.onChangeDestination}
            />
        </div>
        <div className="row col-md-12">
          <div className="col-xs-8 col-xs-offset-4">
            <Input
              type="checkbox"
              label="Incremental"
              labelClassName="col-xs-4"
              wrapperClassName="col-xs-8"
              value={this.props.settings.get('incremental')}
              onChange={this.onChangeIncremental}
              />
          </div>
        </div>
      </div>
    );
  }
});
