# DrawIoParser
Apex class that extracts embedded Draw.io XML diagram data from PNG files stored in Salesforce.

Note: This class may use significant heap memory for large files due to Salesforce's maximum heap size limit (typically 6 MB for synchronous Apex).