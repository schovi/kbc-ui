import React from 'react';
import ApplicationStore from '../../../../stores/ApplicationStore';

export default React.createClass({
  propTypes: {
    configurationId: React.PropTypes.string.isRequired
  },

  bucketId() {
    return 'in.c-keboola-ex-mongodb-' + this.props.configurationId;
  },

  bucketUrl() {
    return ApplicationStore.getSapiBucketUrl(this.bucketId());
  },

  render() {
    return (
      <a target="_blank" href={this.bucketUrl()}>
        {this.bucketId()}
      </a>
    );
  }

});
