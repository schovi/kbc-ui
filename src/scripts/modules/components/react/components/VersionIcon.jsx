import React from 'react';
import ImmutableRenderMixin from '../../../../react/mixins/ImmutableRendererMixin';
import './VersionIcon.less';

export default React.createClass({
  mixins: [ImmutableRenderMixin],

  propTypes: {
    isLast: React.PropTypes.bool
  },

  render() {
    if (this.props.isLast) {
      return <span className="fa fa-check-circle fa-fw kbc-version-icon last" />;
    }

    return <span className="fa fa-circle-o fa-fw kbc-version-icon" />;
  }
});
