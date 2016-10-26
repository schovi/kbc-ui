import React, {PropTypes} from 'react';
import {Modal} from 'react-bootstrap';
import Markdown from '../../../react/common/Markdown';

const content = `
The result contains two tables:

* \`analysis-result-documents\` with document-level results in the following columns:
    * all \`id\` columns from the input table (used as primary keys)
    * \`language\` detected language of the document, as ISO 639-1 language code
    * \`sentimentPolarity\` detected sentiment of the document (_1_, _0_ or _-1_)
    * \`sentimentLabel\` sentiment of the document as a label (_positive_, _neutral_ or _negative_)
    * \`usedChars\` the number of characters used by this document

* \`analysis-result-entities\` with entity-level results has the following columns:
    * all \`id\` columns from the input table
    * \`type\` type of the found entity, e.g. _person_, _organization_ or _tag_
    * \`text\` disambiguated and standardized form of the entity, e.g. _John Smith_, _Keboola_, _safe carseat_

  There are multiple rows per one document. All columns are part of the primary key.
  Note that the table also contains topic tags, marked as _tag_ in the type field.
`;

export default React.createClass({
  propTypes: {
    show: PropTypes.bool,
    onClose: PropTypes.func
  },

  render() {
    return (
      <Modal
        show={this.props.show}
        onHide={this.props.onClose}
        bsSize="large"
      >
        <Modal.Header closeButton>
          <Modal.Title>
            Analysis Result Explanation
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <div className="row">
            <div className="form form-horizontal">
              <div className="form-group">
                <div className="col-sm-offset-1 col-sm-11">
                  <Markdown
                    source={content}
                  />
                </div>
              </div>
            </div>
          </div>
        </Modal.Body>

      </Modal>
    );
  }


});
