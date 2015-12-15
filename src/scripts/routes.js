import App from './react/layout/App';
import ErrorPage from './react/pages/ErrorPage';
import Home from './modules/home/react/Index';
import DataTakeout from './modules/data-takeout/Index';
import Limits from './modules/limits/Index';
import ComponentsOverview from './modules/components/react/pages/ComponentsOverview';

import {extractors, writers, applications} from './modules/components/Routes';
import orchestrationRoutes  from './modules/orchestrations/Routes';
import transformationRoutes from './modules/transformations/Routes';
import jobRoutes from './modules/jobs/Routes';


export default {
  handler: App,
  path: '/',
  title: 'Overview',
  name: 'app',
  defaultRouteHandler: Home,
  defaultRouteName: 'home',
  notFoundRouteHandler: ErrorPage,
  childRoutes: [
    orchestrationRoutes,
    extractors,
    writers,
    applications,
    jobRoutes,
    transformationRoutes,
    {
      name: 'data-takeout',
      title: 'Data Takeout',
      defaultRouteHandler: DataTakeout
    },
    {
      name: 'limits',
      title: 'Limits',
      defaultRouteHandler: Limits
    },
    {
      name: 'components',
      title: 'Components Overview',
      defaultRouteHandler: ComponentsOverview
    }
  ]
};
