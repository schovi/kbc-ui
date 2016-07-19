import createVersionsPage from '../react/pages/Versions';

export default function(componentId, configId) {
  return {
    name: `${componentId}Versions`,
    path: 'versions',
    title: 'Versions',
    defaultRouteHandler: createVersionsPage(componentId, configId)
  };
}
