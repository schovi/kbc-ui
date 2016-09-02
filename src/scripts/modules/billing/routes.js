import Index from './react/Index';
import moment from 'moment';

export default {
  name: 'settings-billing',
  path: 'settings-billing',
  title: 'Billing',
  defaultRouteHandler: Index,
  childRoutes: [
    {
      name: 'settings-billing-month',
      path: ':yearMonth',
      title: function(routerState) {
        const yearMonth = routerState.getIn(['params', 'yearMonth']);
        return 'Billing for ' + moment(yearMonth + '-01').format('MMM, YYYY');
      },
      handler: Index
    }
  ]
};
