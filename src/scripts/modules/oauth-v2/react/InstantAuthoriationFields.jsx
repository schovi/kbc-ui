import React, {PropTypes} from 'react';

export default React.createClass({

  propTypes: {
    componentId: PropTypes.string.isRequired,
    setFormValidFn: PropTypes.func
  },

  getInitialState() {
    return {
      authorizedFor: ''
    };
  },

  componentDidMount() {
    this.revalidateForm();
  },

  revalidateForm() {
    this.props.setFormValidFn(this.isValid());
  },

  isValid() {
    return !!this.state.authorizedFor;
  },

  makeSetStatePropertyFn(prop) {
    return (e) => {
      const val = e.target.value;
      let result = {};
      result[prop] = val;
      this.setState(result);
      this.revalidateForm();
    };
  },

  render() {
    return (
      <div style={{'padding-top': '20px'}} className="form-group">
        <div className="col-xs-12">
          <label className="control-label col-xs-2">
            Description
          </label>
          <div className="col-xs-9">
            <input
              className="form-control"
              type="text"
              name="authorizedFor"
              help="Describe this authorization, e.g by account name."
              defaultValue={this.state.authorizedFor}
              onChange={this.makeSetStatePropertyFn('authorizedFor')}
              autoFocus={true}
            />
            <span className="help-text">
              Describe this authorization, e.g. by account name.
            </span>
          </div>
        </div>
      </div>
    );
  }

});
