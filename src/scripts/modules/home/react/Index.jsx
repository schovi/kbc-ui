import React from 'react';
import JobStatusLabel from '../../../react/common/JobStatusLabel';
import ApplicationStore from '../../../stores/ApplicationStore';
import filesize from 'filesize';
import string from 'underscore.string';

export default React.createClass({

    getInitialState() {
        const currentProject = ApplicationStore.getCurrentProject();
        return {
            "data": {
                "sizeBytes": currentProject.get('dataSizeBytes'),
                "rowsCount": currentProject.get('rowsCount')
            }
        }
    },

    render() {
        return (
            <div className = "container-fluid kbc-main-content">
                <div className="row kbc-extractors-select kbc-overview">
                    <div className="col-sm-3">
                        <div className="panel">
                            <div className="panel-body text-center">
                                <h2>Storage</h2>
                                <h3>{filesize(this.state.data.sizeBytes)}</h3>
                                <h3>{string.numberFormat(this.state.data.rowsCount)} rows</h3>
                            </div>
                        </div>
                    </div>
                    <div className="col-sm-3">
                        <div className="panel">
                            <div className="panel-body text-center">
                                <h2>Orchestrations</h2>
                                <h4>6 configured</h4>
                                <p className="">2 processing and 1 waiting</p>
                                <p className="">
                                    12 success runs <span className="text-muted">/week</span>
                                </p>
                                <p className="">
                                    6 errors <span className="text-muted">/week</span> <span className="badge" style={{backgroundColor: 'red'}}>+12% </span>
                                </p>

                            </div>
                        </div>
                    </div>
                    <div className="col-sm-3">
                        <div className="panel">
                            <div className="panel-body text-center">
                                <h2>Components</h2>
                                <h4>12 extractors, 3 writers</h4>
                                <h4>2 transformation buckets and 3 others</h4>
                                <p className="">12 processing and 1 waiting</p>
                                <p className="">
                                    82 success runs <span className="text-muted">/week</span>
                                </p>
                                <p className="">
                                    6 errors <span className="text-muted">/week</span> <span className="badge" style={{backgroundColor: '#96d130'}}>-6% </span>
                                </p>

                            </div>
                        </div>
                    </div>
                    <div className="col-sm-3">
                        <div className="panel">
                            <div className="panel-body text-center">
                                <h2>Access</h2>
                                <h3>14 Admins</h3>
                                <h3>2 API Tokens</h3>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        );
    }
});