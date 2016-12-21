import React, {PropTypes} from 'react/addons';
import Row from './DateDimensionsRow';

export default React.createClass({
  propTypes: {
    dimensions: PropTypes.object.isRequired,
    configurationId: PropTypes.string.isRequired,
    pid: PropTypes.string.isRequired
  },
  mixins: [React.addons.PureRenderMixin],

  render() {
    return (
     <table className="table table-striped">
       <thead>
        <tr>
          <th>Name</th>
          <th>Include Time</th>
          <th>Identifier</th>
          <th>Template</th>
          <th />
        </tr>
       </thead>
       <tbody>
        {this.props.dimensions.map(this.renderRow)}
       </tbody>
     </table>
    );
  },

  renderRow(dimension) {
    return React.createElement(Row, {
      key: dimension.get('id'),
      dimension: dimension,
      configurationId: this.props.configurationId,
      pid: this.props.pid
    });
  }
});
