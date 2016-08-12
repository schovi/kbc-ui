import React, {PropTypes} from 'react';
const CUSTOM_PROPS = {
  'keboola.ex-zendesk': ['subdomain']
};
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
    const checkProps = CUSTOM_PROPS[this.props.componentId] || [];
    let isCustomValid = true;
    for (let prop of checkProps) {
      isCustomValid = isCustomValid && !!prop;
    }
    return !!this.state.authorizedFor && isCustomValid;
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
            <span className="help-block">
              Describe this authorization, e.g. by account name.
            </span>
          </div>
        </div>
        {this.renderCustomFields()}
      </div>
    );
  },

  renderCustomFields() {
    if (this.props.componentId === 'keboola.ex-zendesk') return this.renderZendeskFields();
    return null;
  },

  renderZendeskFields() {
    return [
      <div className="col-xs-12">
        <label className="control-label col-xs-2">
          Domain
        </label>
        <div className="col-xs-9">
          <input
            className="form-control"
            type="text"
            name="zendeskSubdomain"
            defaultValue={this.state.subdomain}
            onChange={this.makeSetStatePropertyFn('subdomain')}
            autoFocus={true}
          />
          <span className="help-text">
            Zendes Subdomain, e.g. keboola
          </span>
        </div>
      </div>,
      <input type="hidden" name="userData"
        value={JSON.stringify({subdomain: this.state.subdomain})}/>
    ];
  }

});
