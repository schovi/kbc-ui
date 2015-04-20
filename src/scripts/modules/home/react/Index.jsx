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
                                <h2>Size</h2>
                                <h3>34.4TB <small className="badge" style="{{backgroundColor:""}}">+12% / week</small></h3>
                                <h3>250M rows <small className="badge">+3% / week</small></h3>
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
                                            42 / 82 hours total
                                        </div>
                                    </div>
                                    <div className="tr">
                                        <div className="td">
                                            <JobStatusLabel status="error"></JobStatusLabel>
                                        </div>
                                        <div className="td">
                                            4 / 3 hours total
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