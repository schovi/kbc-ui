import hashCode from './../../../utils/hashCode';
import Immutable from 'immutable';

export default function(object) {
  return hashCode(object.get('jobs', Immutable.List())) + hashCode(object.get('mappings', Immutable.Map()));
}
