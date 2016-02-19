import React, {PropTypes} from 'react';

export default React.createClass({
  propTypes: {
    phase: PropTypes.object.isRequired,
    toggleHide: PropTypes.func.isRequired,
    isPhaseHidden: PropTypes.bool.isRequired,
    color: PropTypes.string
  },

  render() {
    let style = {
      'background-color': this.props.color
    };
    if (this.props.isPhaseHidden) {
      style['border-bottom'] = '2px groove';
    }

    return (
      <tr
        style={style}
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
