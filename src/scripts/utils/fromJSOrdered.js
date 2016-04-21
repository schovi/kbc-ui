import {fromJS, Iterable} from 'immutable';

export default function(json) {
  return fromJS(json, function(key, value) {
    var isIndexed = Iterable.isIndexed(value);
    return isIndexed ? value.toList() : value.toOrderedMap();
  });
}