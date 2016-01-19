const sasTemplate = `
1. #### Generate bucket credentials

   Select a redshift bucket and generate credentials.

2. #### Download ODBC redshift driver from the following link:
   <a href="http://docs.aws.amazon.com/redshift/latest/mgmt/configure-odbc-connection.html" target="_blank"> http://docs.aws.amazon.com/redshift/latest/mgmt/configure-odbc-connection.html </a>
3. #### In SAS initiate the connection  from \`ETL Enterprise Guide\`, sample command:

   \`\`\`
    libname RedShift odbc datasrc="RedShift" schema="out.c-sas-va" PRESERVE_COL_NAMES =YES PRESERVE_TAB_NAMES=YES;
   \`\`\`

* If you already have other ODBC driver than Redshift licensed, you can configure a keboola database writer for it and connect to its database.

`;

export default sasTemplate;
