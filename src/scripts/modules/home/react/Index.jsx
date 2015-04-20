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
                <div className="row kbc-extractors-select">
                    <div className="col-sm-4">
                        <div className="panel">
                            <div className="panel-body text-center">
                                <h2>Size</h2>
                                <h3>{filesize(this.state.data.sizeBytes)}</h3>
                                <h3>{string.numberFormat(this.state.data.rowsCount)} rows</h3>
                            </div>
                        </div>
                    </div>
                    <div className="col-sm-4">
                        <div className="panel">
                            <div className="panel-body text-center">
                                <h2>Activity</h2>
                                <div style={{"text-align": "left"}} className="table">
                                    <div className="text-muted">Current</div>
                                    <div className="tr">
                                        <div className="td">
                                            <JobStatusLabel status="waiting"></JobStatusLabel>
                                        </div>
                                        <div className="td">
                                            1
                                        </div>
                                    </div>
                                    <div className="tr">
                                        <div className="td">
                                            <JobStatusLabel status="processing"></JobStatusLabel>
                                        </div>
                                        <div className="td">
                                            6
                                        </div>
                                    </div>
                                    <div className="text-muted">Last Week</div>
                                    <div className="tr">
                                        <div className="td">
                                            <JobStatusLabel status="success"></JobStatusLabel>
                                        </div>
                                        <div className="td">
                                            42 / 82 hours total <small className="badge">+3% </small>
                                        </div>
                                    </div>
                                    <div className="tr">
                                        <div className="td">
                                            <JobStatusLabel status="error"></JobStatusLabel>
                                        </div>
                                        <div className="td">
                                            4 / 3 hours total <small className="badge">-6% </small>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>
                    <div className="col-sm-4">
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