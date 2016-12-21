import React, {PropTypes} from 'react';

export default React.createClass({
  propTypes: {
    component: PropTypes.object
  },

  render() {
    return (
        <span>
          {this.props.component.get('name')} {this.componentType()}
        </span>
    );
  },

  componentType() {
    if (!this.shouldShowType()) {
      return null;
    }

    return <small>{this.props.component.get('type')}</small>;
  },

  shouldShowType() {
    return this.props.component.get('type') === 'extractor' || this.props.component.get('type') === 'writer';
  }

});