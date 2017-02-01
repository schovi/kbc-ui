import React, {PropTypes} from 'react';
import immutableMixin from '../../../../react/mixins/ImmutableRendererMixin';

export default React.createClass({
  mixins: [immutableMixin],

  propTypes: {
    delimiter: PropTypes.string.isRequired,
    enclosure: PropTypes.string.isRequired
  },

  render() {
    return (
      <div className="form-horizontal row">
        <div className="col-md-12">
          <div className="form-group">
            <label className="control-label col-xs-4">
              <span>CSV Delimiter</span>
            </label>
            <div className="col-xs-8">
              <p className="form-control-static">
                <code>
                  {this.props.delimiter}
                </code>
              </p>
            </div>
          </div>
        </div>
        <div className="col-md-12">
          <div className="form-group">
            <label className="control-label col-xs-4">
              <span>CSV Enclosure</span>
            </label>
            <div className="col-xs-8">
              <p className="form-control-static">
                <code>
                  {this.props.enclosure}
                </code>
              </p>
            </div>
          </div>
        </div>
      </div>
    );
  }
});
