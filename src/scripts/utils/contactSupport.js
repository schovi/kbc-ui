import ApplicationStore from '../stores/ApplicationStore';

function webWidget() {
  /*global zE*/
  zE.activate({hideOnClose: true});
}

export default function({type = 'project'}) {
  const settings = ApplicationStore.getKbcVars().getIn(['zendesk', type]);
  /*global zE*/
  zE.activate({hideOnClose: true});
}