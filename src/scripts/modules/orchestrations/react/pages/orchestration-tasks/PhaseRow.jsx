import React, {PropTypes} from 'react';

export default React.createClass({
  propTypes: {
    phase: PropTypes.object.isRequired,
    toggleHide: PropTypes.func.isRequired,
    color: PropTypes.string
  },

  render() {
    return (
      <tr
        style={{'background-color': this.props.color}}
        onClick={this.props.toggleHide}>
        <td colSpan="6" className="kbc-cursor-pointer text-center">
          <div>
            <strong>
              {this.props.phase.get('id')}
            </strong>
          </div>
        </td>
      </tr>
    );
  }

});
