import React from 'react';

import duration from '../../../../../utils/duration';

export default React.createClass({
    propTypes: {
        tables: React.PropTypes.object.isRequired
    },

    rows() {
        return this.props.tables
            .get('tables')
            .map((table) => {
                return (
                    <li key={table.get('id')}>
                        {table.get('id')} <span className="text-muted">{duration(table.get('durationTotalSeconds'), true)}</span>
                    </li>
                );
            }).toArray();
    },

    render() {
        return (
            <ul>{this.rows()}</ul>
        );
    }
});