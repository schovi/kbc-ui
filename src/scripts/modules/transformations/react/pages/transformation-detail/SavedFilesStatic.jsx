import React, {PropTypes} from 'react';

export default React.createClass({
  propTypes: {
    tags: PropTypes.object.isRequired,
    onEditStart: PropTypes.func.isRequired
  },

  render() {
    return this.props.tags.count() ? this.tagsList() :
      this.emptyState();
  },

  tagsList() {
    return (
      <div>
        {this.props.tags.map(this.renderTag)}
        {this.startEditButton()}
      </div>
    );
  },

  emptyState() {
    return (
      <div className="help-block">
        <small>No files will be downloaded.</small> {this.startEditButton()}
      </div>
    );
  },

  renderTag(tagName) {
    return (
      <span key={tagName} className="label kbc-label-rounded-small label-default">
        {tagName}
      </span>
    );
  },

  startEditButton() {
    return (
      <button className="btn btn-link" onClick={this.props.onEditStart}>
        <span className="kbc-icon-pencil" /> Edit Tags
      </button>
    );
  }

});
