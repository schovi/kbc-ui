

export function modifyProjectPageUrl(pathname) {
  return pathname.replace(/^(\/admin\/projects\/)([0-9]+)/, '$1project');
}

export function sendPageView() {
  /* global ga */
  ga('send', 'pageview', modifyProjectPageUrl(window.location.pathname));
}