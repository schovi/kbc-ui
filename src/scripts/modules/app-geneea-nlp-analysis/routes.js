import Index from './react/Index';

const componentId = 'geneea-nlp-analysis';

export default {
  name: componentId,
  path: `${componentId}/:config`,
  isComponent: true,
  defaultRouteHandler: Index
  // requireData: [
  // ]

};
