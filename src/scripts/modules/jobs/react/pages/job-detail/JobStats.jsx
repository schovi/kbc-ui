import React from 'react';
import {addons} from 'react/addons';
import Loader from '../../../../../react/common/Loader';

import {filesize} from '../../../../../utils/utils';
import TablesList from './TablesList';
import FilesPie from './FilesPie';

export default React.createClass({
    propTypes: {
        stats: React.PropTypes.object.isRequired,
        isLoading: React.PropTypes.bool.isRequired
    },
    mixins: [addons.PureRenderMixin],

    dataSize() {
        return filesize(this.props.stats.getIn(['files', 'total', 'dataSizeBytes', 'total']));
    },

    filesCount() {
        return this.props.stats.getIn(['files', 'total', 'count']);
    },

    loader() {
       return this.props.isLoading ? <Loader/> : '';
    },

    pieData() {
        return this.props.stats.getIn(['files', 'tags', 'tags']);
    },

    render() {
        return (
            <div className="row clearfix">
                <div className="col-md-4">
                    <h4>
                        Imported Tables <small>{this.props.stats.getIn(['tables', 'import', 'totalCount'])} imports total</small> {this.loader()}
                    </h4>
                    <TablesList tables={this.props.stats.getIn(['tables', 'import'])}/>
                </div>
                <div className="col-md-4">
                    <h4>Exported Tables <small>{this.props.stats.getIn(['tables', 'export', 'totalCount'])} exports total</small></h4>
                    <TablesList tables={this.props.stats.getIn(['tables', 'export'])}/>
                </div>
                <div className="col-md-3">
                    <h4>Data Transfer <small>{this.filesCount()} files total</small></h4>
                    <div className="text-center">
                        <h1>{this.dataSize()}</h1>
                        <FilesPie data={this.pieData()} />
                    </div>
                </div>
            </div>
        );
    }
});