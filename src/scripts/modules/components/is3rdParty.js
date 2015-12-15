import {Map} from 'immutable';

export default function(component) {
  return component.get('flags', Map()).contains('3rdParty');
}
