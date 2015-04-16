import React from 'react';
import JobStatusLabel from '../../../react/common/JobStatusLabel'

export default React.createClass({
    render() {
        return (
            <div className = "container-fluid kbc-main-content">
                <div className="row kbc-extractors-select">
                    <div className="col-sm-4">
                        <div className="panel">
                            <div className="panel-body text-center">
                                <h2>Data</h2>
                                <h3>34.4TB</h3>
                                <h3>250M rows</h3>
                            </div>
                        </div>
                    </div>
                    <div className="col-sm-4">
                        <div className="panel">
                            <div className="panel-body text-center">
                                <h2>Activity</h2>
                                <div style={{"text-align": "left"}} className="table">
                                    
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
                                    <div className="tr">
                                        <div className="td">
                                            <JobStatusLabel status="success"></JobStatusLabel>
                                        </div>
                                        <div className="td">
                                            42 / 24h
                                        </div>
                                    </div>
                                    <div className="tr">
                                        <div className="td">
                                            <JobStatusLabel status="error"></JobStatusLabel>
                                        </div>
                                        <div className="td">
                                            4 / 24h
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>
                    <div className="col-sm-4">
                        <div className="panel">
                            <div className="panel-body text-center">
                                <h2>Users</h2>
                                <h3>14</h3>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        );
    }
});