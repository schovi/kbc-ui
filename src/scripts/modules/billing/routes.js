import Index from './react/Index';

export default {
  name: 'settings-billing',
  path: 'settings-billing',
  title: 'Billing',
  defaultRouteHandler: Index,
  childRoutes: [
    {
      name: 'settings-billing-month',
      path: ':month',
      title: function(routerState) {
        const month = routerState.getIn(['params', 'month']);
        return 'Billing for ' + month;
      },
      handler: Index
    }
  ]
};
