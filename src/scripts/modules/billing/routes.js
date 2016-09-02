import Index from './react/Index';

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
        const date = (new Date(yearMonth + '-01')).toDateString().split(' ');
        return 'Billing for ' + date[1] + ', ' + date[3];
      },
      handler: Index
    }
  ]
};
