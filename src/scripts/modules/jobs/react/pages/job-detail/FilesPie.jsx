import React from 'react';
import dimple from 'dimple/dist/dimple.v2.1.1.js';

const WIDTH = 140;

export default React.createClass({
    propTypes: {
        data: React.PropTypes.object.isRequired
    },

    getData() {
        if (this.props.data.count() <= 1) {
            return [];
        } else {
            return this.props.data.toJS();
        }
    },

    componentDidMount() {
        const width = this.getDOMNode().offsetWidth;
        const svg = dimple.newSvg(this.getDOMNode(), WIDTH, WIDTH);
        const chart = new dimple.chart(svg, this.getData());
        chart.addMeasureAxis("p", "count");
        const ring = chart.addSeries("tag", dimple.plot.pie);
        ring.innerRadius = "50%";
        chart.draw();
        this.chart = chart;
    },

    componentDidUpdate() {
        this.refreshGraph();
    },

    refreshGraph() {
        this.chart.data = this.getData();
        this.chart.svg.style('width', WIDTH);
        this.chart.draw(200);
    },

    render() {
        return (
          <div/>
        );
    }

});