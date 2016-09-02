import App from './react/layout/App';
import ErrorPage from './react/pages/ErrorPage';
import Home from './modules/home/react/Index';
import DataTakeout from './modules/data-takeout/Index';
import Limits from './modules/limits/Index';
import billingRoutes from './modules/billing/routes';
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
    billingRoutes,
    transformationRoutes,
    {
      name: 'data-takeout',
      title: 'Data Takeout',
      defaultRouteHandler: DataTakeout
    },
    {
      name: 'settings-limits',
      title: 'Settings',
      defaultRouteHandler: Limits
    },
    {
      name: 'limits',
      title: 'Project Settings',
      defaultRouteHandler: Limits
    },
    {
      name: 'components',
      title: 'Components Overview',
      defaultRouteHandler: ComponentsOverview
    }
  ]
};
