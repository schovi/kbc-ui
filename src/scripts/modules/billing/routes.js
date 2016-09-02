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
        return 'Billing for ' + yearMonth;
      },
      handler: Index
    }
  ]
};
