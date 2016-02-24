
export function sendPageView() {
  /* global ga */
  ga('send', 'pageview', window.location.pathname);
}