import ComponentDetail from '../components/react/pages/component-detail/ComponentDetail';
import ComponentsStore from '../components/stores/ComponentsStore';
import injectProps from '../components/react/injectProps';

export default function(componentId, componentRoutes) {
  return {
    name: `${componentId}-index`,
    defaultRouteHandler: injectProps({component: componentId})(ComponentDetail),
    path: componentId,
    title: () => {
      return ComponentsStore.getComponent(componentId).get('name');
    },
    childRoutes: componentRoutes
  };
}