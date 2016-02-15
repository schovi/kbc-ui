import React, {PropTypes} from 'react';

export default React.createClass({
  propTypes: {
    phase: PropTypes.object.isRequired,
    toggleHide: PropTypes.func.isRequired
  },

  render() {
    return (
      <tr onClick={this.props.toggleHide}>
        <td colSpan="6" className="kbc-cursor-pointer">
          <div>
            <span className="label label-default kbc-label-rounded">
              {this.props.phase.get('id')}
            </span>
          </div>
        </td>
      </tr>
    );
  }

});
