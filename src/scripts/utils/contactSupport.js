
import ApplicationStore from '../stores/ApplicationStore';

function oldFeedBackTab({dropboxId = '', url = '', subject = ''}) {
  /*global Zenbox*/
  /* eslint camelcase: 0 */
  Zenbox.init({
    request_subject: subject,
    dropboxID: dropboxId,
    url: url
  });
  Zenbox.show();
}

function webWidget() {
  /*global zE*/
  zE.activate({hideOnClose: true});
}

export default function({type = 'project', subject = ''}) {
  const settings = ApplicationStore.getKbcVars().getIn(['zendesk', type]);
  if (settings.get('dropboxId')) {
    oldFeedBackTab({
      dropboxId: settings.get('dropboxId'),
      url: settings.get('url'),
      subject: subject
    });
  } else {
    webWidget();
  }
}