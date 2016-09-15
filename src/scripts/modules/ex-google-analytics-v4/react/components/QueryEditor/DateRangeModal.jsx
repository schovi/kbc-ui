import React, {PropTypes} from 'react';
import moment from 'moment';
import {TabbedArea, TabPane, Button, Modal} from 'react-bootstrap';
import DatePicker from 'react-datepicker';

const DATE_FORMAT = 'YYYY-MM-DD';
const SUGGESTIONS = {
  'Today': {
    start: 'today',
    end: 'tomorrow -1 second'
  },
  'Last 7 days': {
    start: '-7 days',
    end: 'today'
  },
  'Last 2 Months': {
    start: '-2 months',
    end: 'today'
  },
  'Last 2 Weeks': {
    start: '-2 weeks',
    end: 'today'
  },
  'Last Month': {
    start: 'midnight first day of last month',
    end: 'midnight last day of last month'
  },
  'This Month': {
    start: 'midnight first day of this month',
    end: 'midnight last day of this month'
  },
  'Last Week': {
    start: 'monday last week',
    end: 'sunday last week'
  },
  'This Week': {
    start: 'monday this week',
    end: 'today'
  }
};

export default React.createClass({
  propTypes: {
    startDate: PropTypes.string.isRequired,
    endDate: PropTypes.string.isRequired,
    onSet: PropTypes.func.isRequired,
    onCancel: PropTypes.func.isRequired,
    show: PropTypes.bool.isRequired
  },

  getInitialState() {
    return this.getStateFromProps(this.props);
  },

  getStateFromProps(props) {
    const rangeType = this.getDatePropsType(props);
    return {
      rangeType: rangeType,
      absoluteStart: rangeType === 'absolute' ? moment(props.startDate) : '',
      absoluteEnd: rangeType === 'absolute' ? moment(props.endDate) : '',
      relativeStart: rangeType === 'relative' ? props.startDate : '',
      relativeEnd: rangeType === 'relative' ? props.endDate : ''
    };
  },

  componentWillReceiveProps(nextProps) {
    this.setState(this.getStateFromProps(nextProps));
  },

  getDatePropsType(props) {
    const {startDate, endDate} = props;
    const startValid = moment(startDate).isValid();
    const endValid = moment(endDate).isValid();
    const result = (startValid && endValid) ? 'absolute' : 'relative';
    return result;
  },

  render() {
    return (
      <Modal show={this.props.show} onHide={this.props.onCancel}>
        <Modal.Header closeButton>
          <Modal.Title>Change Date Range</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <TabbedArea activeKey={this.state.rangeType} onSelect={this.onSelectTab} animation={false}>
            <TabPane eventKey="relative" tab="Relative">
              {this.renderRelative()}
            </TabPane>
            <TabPane eventKey="absolute" tab="Absolute">
              {this.renderAbsolute()}
            </TabPane>
          </TabbedArea>

        </Modal.Body>
        <Modal.Footer>
          <Button
            bsStyle="link"
            onClick={this.props.onCancel}>
            Close
          </Button>
          <Button
            bsStyle="primary"
            disabled={!this.isValid()}
            onClick={this.setAndClose}>
            Change
          </Button>
        </Modal.Footer>
      </Modal>
    );
  },

  renderAbsolute() {
    const startDateProps = {
      onChange: (val) => this.setState({absoluteStart: val}),
      selected: this.state.absoluteStart,
      maxDate: this.state.absoluteEnd
    };

    const endDateProps = {
      onChange: (val) => this.setState({absoluteEnd: val}),
      selected: this.state.absoluteEnd,
      minDate: this.state.absoluteStart
    };

    return (
      <form className="form-horizontal">
        <h4> Specify absolute date range </h4>
        {this.renderPicker('Since', startDateProps)}
        {this.renderPicker('Until', endDateProps)}
      </form>
    );
  },

  renderPicker(name, extraProps) {
    return (
      <div className="form-group form-group-sm">
        <label className="col-sm-1 control-label">
          {name}
        </label>
        <div className="col-sm-6">
          <DatePicker
            name={name}
            dateFormat={DATE_FORMAT}
            {...extraProps}
          />
        </div>
      </div>
    );
  },

  selectSuggestion(e) {
    const range = SUGGESTIONS[e.target.value];
    this.setState({
      relativeStart: range.start,
      relativeEnd: range.end
    });
  },

  renderRelative() {
    const startDateProps = {
      onChange: (e) => this.setState({relativeStart: e.target.value}),
      value: this.state.relativeStart
    };

    const endDateProps = {
      onChange: (e) => this.setState({relativeEnd: e.target.value}),
      value: this.state.relativeEnd
    };

    return (
      <form className="form-horizontal">
        <h4> Specify relative date range {' '}
          <select
            className="input-sm"
            defaultValue=""
            onChange={this.selectSuggestion}
          >
            {[].concat('').concat(Object.keys(SUGGESTIONS)).map((op) =>
              (<option
                 disabled={op === ''}
                 key={op}
                 value={op} >
            {op === '' ? 'or choose from suggestions' : op}
              </option>)
             )}

          </select>
        </h4>
        {this.renderRelativeInput('Since', startDateProps)}
        {this.renderRelativeInput('Until', endDateProps)}
      </form>
    );
  },

  renderRelativeInput(name, extraProps) {
    return (
      <div className="form-group form-group-sm">
        <label className="col-sm-1 control-label">
          {name}
        </label>
        <div className="col-sm-6">
          <input
            type="text"
            className="form-control"
            name={name}
            {...extraProps}
          />
        </div>
      </div>
    );
  },

  onSelectTab(selectedTab) {
    this.setState({rangeType: selectedTab});
  },

  setAndClose() {
    const {rangeType, absoluteStart, absoluteEnd, relativeStart, relativeEnd} = this.state;
    const start = rangeType === 'relative' ? relativeStart : absoluteStart.format(DATE_FORMAT);
    const end = rangeType === 'relative' ? relativeEnd : absoluteEnd.format(DATE_FORMAT);
    this.props.onSet(start, end);
    this.props.onCancel();
  },

  isValid() {
    if (this.state.rangeType === 'absolute') {
      const {absoluteStart, absoluteEnd} = this.state;
      const startValid = absoluteStart && moment(absoluteStart).isValid();
      const endValid = absoluteEnd && moment(absoluteEnd).isValid();
      return startValid && endValid;
    }
    const {relativeStart, relativeEnd} = this.state;
    return relativeStart !== '' && relativeEnd !== '';
  }
});
