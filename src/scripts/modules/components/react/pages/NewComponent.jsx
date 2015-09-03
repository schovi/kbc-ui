import React, {PropTypes} from 'react';
import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import ComponentsStore from '../../stores/ComponentsStore';
import NewComponentSelection from '../components/NewComponentSelection';

export default React.createClass({
  mixins: [createStoreMixin(ComponentsStore)],
  propTypes: {
    type: PropTypes.string.isRequired
  },

  getStateFromStores() {
    const components = ComponentsStore
      .getFilteredForType(this.props.type)
      .filter((component) => {
        return !component.get('flags').includes('excludeFromNewList');
      });

    return {
      components: components,
      filter: ComponentsStore.getFilter(this.props.type)
    };
  },

  componentWillReceiveProps() {
    this.setState(this.getStateFromStores());
  },

  render() {
    return (
      <NewComponentSelection
        className="container-fluid kbc-main-content"
        components={this.state.components}
        filter={this.state.filter}
        componentType={this.props.type}
        />
    );
  }

});