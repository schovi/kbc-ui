import React from 'react';
import {Link} from 'react-router';

export default React.createClass({

  propTypes: {
    componentId: React.PropTypes.string.isRequired,
    configId: React.PropTypes.string.isRequired
  },

  render() {
    if (this.props.componentId === 'transformation') {
      return (
        <span>
        Configuration copied,&nbsp;
          <Link
            to="transformationBucket"
            params={{config: this.props.configId}}
          >
            go to the new configuration
          </Link>.
      </span>
      );
    } else {
      return (
        <span>
          Configuration copied successfully.
        </span>
      );
    }
  }
});
