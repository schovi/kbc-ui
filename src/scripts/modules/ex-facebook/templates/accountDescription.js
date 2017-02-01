const defaultComponentId = 'keboola.ex-facebook';
export default function(componentId) {
  function getFbAdsText(originalText) {
    const isCapitalized = /[A-Z]/.test(originalText[0]);
    let lastLetter = '';
    if (originalText.slice(-1) === 's') lastLetter = 's';
    const stem = isCapitalized ? 'Ad Account' : 'ad account';
    return stem + lastLetter;
  }

  return function(text) {
    if (componentId === defaultComponentId) return text;
    if (componentId === 'keboola.ex-facebook-ads') return getFbAdsText(text);
    return 'Missing account description';
  };
}
