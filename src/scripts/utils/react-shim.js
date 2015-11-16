
// keboola namespace for react components https://github.com/facebook/react/issues/1939
const DOMProperty = require('react/lib/DOMProperty');
if (process.env.NODE_ENV === 'production') {
  DOMProperty.ID_ATTRIBUTE_NAME = 'data-keboolaid';
}

require('react/addons');
require('react');
