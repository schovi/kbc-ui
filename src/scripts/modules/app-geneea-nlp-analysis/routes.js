import Index from './react/Index';
import installedComponentsActions from '../components/InstalledComponentsActionCreators';
import HeaderButtons from './react/HeaderButtons';

const componentId = 'geneea-nlp-analysis';

export default {
  name: componentId,
  path: `${componentId}/:config`,
  isComponent: true,
  defaultRouteHandler: Index,
  headerButtonsHandler: HeaderButtons,
  requireData: [
    (params) => installedComponentsActions.loadComponentConfigData(componentId, params.config)
  ]

};
