import React, {PropTypes} from 'react';
import ConfirmButtons from '../../../../../react/common/ConfirmButtons';
import CodeMirror from 'react-code-mirror';
import parseQueries from './parseQueries';

export default React.createClass({
  propTypes: {
    queries: PropTypes.object.isRequired,
    isSaving: PropTypes.bool.isRequired,
    onChange: PropTypes.func.isRequired,
    onCancel: PropTypes.func.isRequired,
    onSave: PropTypes.func.isRequired
  },

  render() {
    return (
      <div>
        <div>
          <div className="edit">
            <CodeMirror
              value={this.props.queries.join('\n\n')}
              theme="solarized"
              lineNumbers={true}
              mode="text/x-mysql"
              lineWrapping={true}
              onChange={this.handleChange}
              readOnly={this.props.isSaving}
              />
          </div>
        </div>
        <div>
          <ConfirmButtons
            isSaving={this.props.isSaving}
            onSave={this.props.onSave}
            onCancel={this.props.onCancel}
            placement="left"
            />
        </div>
      </div>
    );
  },

  handleChange(e) {
    const parsed = parseQueries(e.target.value);
    console.log('q', parsed);
    this.props.onChange(parsed);
  }
});