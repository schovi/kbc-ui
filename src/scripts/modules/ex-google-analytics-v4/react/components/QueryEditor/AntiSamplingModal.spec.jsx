import React from 'react';
import {Map} from 'immutable';
import AntiSamplingModal from './AntiSamplingModal';

describe('<AntiSamplingModal />', () => {
  const emptyFn = function() {};
  const fnProps = {
    onHideFn: emptyFn,
    updateLocalState: emptyFn,
    onSaveFn: emptyFn
  };
  it('should render hidden modal', () => {
    shallowSnapshot(
      <AntiSamplingModal
        show={false}
        localState={Map()}
        {...fnProps}/>);
  });

  it('should render modal', () => {
    shallowSnapshot(
      <AntiSamplingModal
        show={true}
        localState={Map()}
        {...fnProps}/>);
  });
});
