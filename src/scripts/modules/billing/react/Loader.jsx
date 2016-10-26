import React from 'react';
import {Loader} from 'kbc-react-components';

export default React.createClass({

  render() {
    return (
      <div className="text-center" style={{padding: '2em 0'}}>
        <Loader className="fa-2x"/>
      </div>
    );
  }

});
