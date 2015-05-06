import React from 'react';
import classnames from 'classnames';
import {CollapsableMixin, Button} from 'react-bootstrap';

export default React.createClass({
    propTypes: {
        header: React.PropTypes.string.isRequired
    },
    mixins: [CollapsableMixin],

    getCollapsableDOMNode: function(){
        return this.refs.panel.getDOMNode();
    },

    getCollapsableDimensionValue: function(){
        return this.refs.panel.getDOMNode().scrollHeight;
    },

    onHandleToggle(e) {
        e.preventDefault();
        console.log('toggle');
        this.setState({expanded:!this.state.expanded});
    },

    render() {
        let styles = this.getCollapsableClassSet();
        console.log('styles', styles);
        return (
            <div>
                <div className="row">
                    <a href="#" onClick={this.onHandleToggle}>
                        <h4>{this.props.header}</h4>
                    </a>
                </div>
                <div ref='panel' className={classnames(styles, 'row')}>
                    {this.props.children}
                </div>
            </div>
        );
    }

});