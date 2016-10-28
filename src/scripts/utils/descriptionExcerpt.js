import removeMarkdown from 'remove-markdown';

// remove markdown markup and trim to 100 characters
export default function(description) {
  var plainText = removeMarkdown(description);
  if (plainText.length > 100) {
    plainText = plainText.substring(0, 100) + '...';
  }
  return plainText;
}
