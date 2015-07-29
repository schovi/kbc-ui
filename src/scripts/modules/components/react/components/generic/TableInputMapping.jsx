import React, {PropTypes} from 'react';
//import Detail from './TableInputMappingDetail';
//import Header from './TableInputMappingHeader';


export default React.createClass({
  propTypes: {
    input: PropTypes.object.isRequired
  },

  render() {
    return (
      <div>
        <h2>InputMapping</h2>
        {this.content()}
      </div>
    );
  },

  content() {
    if (this.props.input.length >= 1) {
      return (
        <span>
          <div>Mappings</div>
          <code>{this.props.input}</code>
        </span>
      );
    } else {
      return (
        <div className="well text-center">
          <p>No table input mapping assigned yet.</p>
        </div>
      );
    }
  }

});
