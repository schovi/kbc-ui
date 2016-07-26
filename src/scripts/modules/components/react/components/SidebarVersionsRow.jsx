import React from 'react';
import CreatedWithIcon from '../../../../react/common/CreatedWithIcon';
import ImmutableRendererMixin from '../../../../react/mixins/ImmutableRendererMixin';
import {Link} from 'react-router';

module.exports = React.createClass({
  displayName: 'LatestVersionsRow',
  mixins: [ImmutableRendererMixin],
  propTypes: {
    version: React.PropTypes.object.isRequired,
    bucketId: React.PropTypes.string.isRequired
  },

  getVersionDescription() {
    return this.props.version.get('changeDescription') || 'No description.';
  },

  render: function() {
    const linkParams = {
      bucketId: this.props.bucketId
    };
    return (
      <Link
        className="list-group-item"
        to="transformation-versions"
        params={linkParams}
      >
        <span className="table">
          <span className="tr">
            <span className="td">
              <span className="fa fa-circle-o fa-fw version-icon"></span>
            </span>
            <span className="td">
              <div>
                <div>
                  {this.getVersionDescription()}
                </div>
                <div>
                  {this.props.version.getIn(['creatorToken', 'description'], 'unknown')}
                </div>
                <div>
                  <small className="text-muted pull-left">
                    #{this.props.version.get('version')}
                  </small>
                  <small className="text-muted pull-right">
                    <CreatedWithIcon createdTime={this.props.version.get('created')} />
                  </small>
                </div>
              </div>
            </span>
          </span>
        </span>
      </Link>
    );
  }
});
