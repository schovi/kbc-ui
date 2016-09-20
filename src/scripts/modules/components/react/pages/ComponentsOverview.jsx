import React from 'react/addons';
import SearchRow from '../../../../react/common/SearchRow';
import ComponentsStore from '../../stores/ComponentsStore';
import fuzzy from 'fuzzy';
import ComponentCheck from './ComponentCheck';

import createStoreMixin from '../../../../react/mixins/createStoreMixin';
import './componentsOverview.less';

export default React.createClass({
  mixins: [createStoreMixin(ComponentsStore)],

  getStateFromStores() {
    return {
      components: ComponentsStore.getAll()
    };
  },

  getInitialState() {
    return {
      filter: ''
    };
  },

  render() {
    return (
      <div className="container-fluid kbc-main-content">
        <SearchRow
          onChange={this.handleFilterChange}
          query={this.state.filter} />
        {this.components()}
      </div>
    );
  },

  components() {
    return this.filteredComponents()
      .toIndexedSeq()
      .sortBy(function(component) {
        return component.get('id').toLowerCase();
      })
      .map(function(component) {
        return (
          <ComponentCheck
            component={component}
            key={component.get('id')}
            />
        );
      }
    ).toArray();
  },

  handleFilterChange(value) {
    this.setState({filter: value});
  },

  filteredComponents() {
    var filter = this.state.filter;
    return this.state.components
      .filter(function(value) {
        return fuzzy.match(filter, value.get('name').toString()) || fuzzy.match(filter, value.get('id').toString());
      }
    );
  }

});
