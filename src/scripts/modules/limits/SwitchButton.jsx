import React, {PropTypes} from 'react';
import EditLimitModal from './EditLimitModal';
import Switch from 'rc-switch';
import contactSupport from '../../utils/contactSupport';

export default React.createClass({
  propTypes: {
    limit: PropTypes.object.isRequired,
    canEdit: PropTypes.bool
  },

  getInitialState() {
    return {
      isOpen: false
    };
  },

  render() {
    const {limit} = this.props;
    return (
      <span>
        <Switch
          className="kbc-switch"
          checkedChildren={'✓'}
          unCheckedChildren={'x'}
          checked={limit.get('limitValue')}
          onChange={this.handleChange}
          />
        <EditLimitModal
          limit={limit}
          onHide={this.closeModal}
          isOpen={this.state.isOpen}
          />
      </span>
    );
  },

  handleChange() {
    if (this.props.canEdit) {
      this.openModal();
    } else {
      contactSupport();
    }
  },

  openModal() {
    this.setState({
      isOpen: true
    });
  },

  closeModal() {
    this.setState({
      isOpen: false
    });
  }
});