import React, {PropTypes} from 'react';
import Markdown from '../../../../react/common/Markdown';
import sasTemplate  from './sasTemplate';

export default React.createClass({
  propTypes: {
    componentId: PropTypes.string
  },

  render() {
    const source = this.getSourceTemplate();
    return (
      <Markdown
        source={source}
      />
    );
  },

  getSourceTemplate() {
    switch (this.props.componentId) {
      case 'wr-portal-sas':
        return sasTemplate;
      default:
        return '';
    }
  }

});
