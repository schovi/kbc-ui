import React from 'react';
import {ModalTrigger} from 'react-bootstrap';
import NewTransformationModal from '../modals/NewTransformation';


export default React.createClass({

    render() {
        return (
            <span>
                <ModalTrigger modal={<NewTransformationModal/>}>
                    <button className="btn btn-success">
                        <span className="kbc-icon-plus"></span> Add Transformation
                    </button>
                </ModalTrigger>
            </span>
        );
    }
});