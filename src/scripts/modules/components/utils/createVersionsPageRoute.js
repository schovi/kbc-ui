import createVersionsPage from '../react/pages/Versions';

export default function(componentId, configId, routeUniqueName) {
  return {
    name: routeUniqueName || `${componentId}-versions`,
    path: 'versions',
    title: 'Versions',
    defaultRouteHandler: createVersionsPage(componentId, configId)
  };
}
