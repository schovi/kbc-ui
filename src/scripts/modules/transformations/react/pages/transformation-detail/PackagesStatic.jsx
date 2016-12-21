import React, {PropTypes} from 'react';

export default React.createClass({
  propTypes: {
    packages: PropTypes.object.isRequired,
    onEditStart: PropTypes.func.isRequired,
    transformationType: PropTypes.string.isRequired
  },

  render() {
    return this.props.packages.count() ? this.packagesList() :
      this.emptyState();
  },

  packagesList() {
    return (
      <div>
        <div className="help-block">
          {this.props.transformationType === 'r' ? (
            <span>
              These packages will be installed from CRAN and loaded to the R script environment.
            </span>) : null}
          {this.props.transformationType === 'python' ? (
            <span>
              These packages will be installed from PyPI to the Python script environment.
              Do not forget to load them using <code>import</code>.
            </span>) : null}
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
        <small>No packages will be installed.</small> {this.startEditButton()}
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
        <span className="kbc-icon-pencil" /> Edit Packages
      </button>
    );
  }

});
