import Index from './react/Index';
import installedComponentsActions from '../components/InstalledComponentsActionCreators';

const componentId = 'geneea-nlp-analysis';

export default {
  name: componentId,
  path: `${componentId}/:config`,
  isComponent: true,
  defaultRouteHandler: Index,
  requireData: [
    (params) => installedComponentsActions.loadComponentConfigData(componentId, params.config)
  ]

};
