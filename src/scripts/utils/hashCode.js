import fromJSOrdered from './fromJSOrdered';

export default function(object) {
  return parseInt(fromJSOrdered(object.toJS()).hashCode(), 10);
}
