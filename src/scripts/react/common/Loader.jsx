import react from 'react';
import classnames from 'classnames';

export default  React.createClass({
  render() {
    return (
        <span className={classnames('fa fa-spin fa-spinner', this.props.className)}/>
    );
  }

});

