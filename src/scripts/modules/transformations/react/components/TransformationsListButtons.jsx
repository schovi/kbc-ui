import React from 'react';
import {ModalTrigger} from 'react-bootstrap';
import NewTransformationModal from '../modals/NewTransformation';
import RoutesStore from '../../../../stores/RoutesStore';
import TransformationBucketsStore from '../../stores/TransformationBucketsStore';
import createStoreMixin from '../../../../react/mixins/createStoreMixin';



export default React.createClass({
  mixins: [createStoreMixin(TransformationBucketsStore)],

  getStateFromStores() {
    return {
      bucket: TransformationBucketsStore.get(RoutesStore.getCurrentRouteParam('bucketId'))
    };
  },

  render() {
    return (
      <span>
        <ModalTrigger modal={<NewTransformationModal bucket={this.state.bucket}/>}>
          <button className="btn btn-success">
            <span className="kbc-icon-plus"></span> Add Transformation
          </button>
        </ModalTrigger>
      </span>
    );
  }
});