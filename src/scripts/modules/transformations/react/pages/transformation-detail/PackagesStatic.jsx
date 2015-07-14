import React, {PropTypes} from 'react';

export default React.createClass({
  propTypes: {
    packages: PropTypes.object.isRequired,
    onEditStart: PropTypes.func.isRequired
  },

  render() {
    return this.props.packages.count() ? this.packagesList() :
      this.emptyState();
  },

  packagesList() {
    return (
      <div>
        <div className="help-block">
          These packages will be installed into the Docker container running the R script.
          Do not forget to load them using <code>library()</code>
        </div>
        <div>
          {this.props.packages.map(this.renderPackage)}

          {this.startEditButton()}
        </div>
      </div>
    );
  },

  emptyState() {
    return (
      <div className="help-block">
        <small>No packages will installed.</small> {this.startEditButton()}
      </div>
    );
  },

  renderPackage(packageName) {
    return (
      <span key={packageName} className="label kbc-label-rounded-small label-default">
        {packageName}
      </span>
    );
  },

  startEditButton() {
    return (
      <button className="btn btn-link" onClick={this.props.onEditStart}>
        <span className="kbc-icon-pencil"></span> Edit Packages
      </button>
    );
  }

});