public class DrawIoParser
{
    private static String MXFILE = 'mxfile';

    public static String ExtractXML(Id contentVersionId)
    {
        String xmlContent;
        Blob versionData = [SELECT VersionData FROM ContentVersion WHERE Id = :contentVersionId].versionData;
        String encodedUrl = EncodingUtil.convertToHex(versionData).replaceAll('(.{2})','%$1');
        String recoveredText = EncodingUtil.urlDecode(encodedUrl,'iso-8859-1');
        Integer startIndex = recoveredText.indexOf('tEXt');
        if (startIndex != -1)
        {
            Integer nextChunkIndex = startIndex + 4;
            String tEXtContent = recoveredText.substring(nextChunkIndex);

            List<String> tEXtParts = tEXtContent.split('\\u0000');
            for (Integer i = 0; i < tEXtParts.size(); i += 2)
            {
                if (i + 1 < tEXtParts.size())
                {
                    String key = tEXtParts[i];
                    String value = tEXtParts[i + 1];
                    if (key == MXFILE)
                    {
                        String startTag = '%3CmxGraphModel';
                        String endTag = '%2FmxGraphModel';
                        Integer startTagIndex = value.indexOf(startTag);
                        Integer endTagIndex = value.indexOf(endTag);

                        if (startTagIndex != -1 && endTagIndex != -1 && endTagIndex > startTagIndex)
                        {
                            String mxfileValue = value.substring(startTagIndex, endTagIndex + endTag.length());
                            String decodedMXFileValue = EncodingUtil.urlDecode(mxfileValue, 'UTF-8');
                            if (!String.isEmpty(decodedMXFileValue)) xmlContent = decodedMXFileValue;
                        }
                        else
                        {
                            System.assert(false, 'Invalid Data');
                        }
                    }
                }
            }
        }
        else
        {
            System.assert(false, 'Invalid Data');
        }
        return xmlContent;
    }
}