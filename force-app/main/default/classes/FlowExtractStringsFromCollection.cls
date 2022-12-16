public class FlowExtractStringsFromCollection {
    public class ExtractStringsException extends Exception {}
  
    @InvocableMethod(label='Extract Strings From Collection' description='Extract and return field values from a list of records using a provided field API name as the unique value' category='Util')
    public static List <Result> extract(List<Request> requestList) {
        List<Result> outputStrings =  new List<Result>();
        
        for (Request request: requestList) {
            if (request.inputRecordCollection == null || request.inputRecordCollection.size() == 0) {
                throw new ExtractStringsException('Input record list is required, but empty');
            }
            if (request.fieldAPIName == null || request.fieldAPIName.length() == 0) {
                throw new ExtractStringsException('Field to dedupe on is required, but empty');
            }
            if (request.dedupeValues == null) {
                request.dedupeValues = true;
            }
            Result result = new Result();
         	result.fieldValueCollection = getUniqueTextCollection(request);
          	result.fieldValueString = String.join(result.fieldValueCollection, ',');
            outputStrings.add(result);
        }
        return outputStrings;
    }

    private static List<String> getUniqueTextCollection(Request request) {
        Set<String> stringsSet = new Set<String>();
        List<String> stringsList = new List<String>{};
        for (SObject record : request.inputRecordCollection) {
            String fieldValue = String.valueOf(record.get(request.fieldAPIName));
            if (fieldValue != null) {
                if (request.dedupeValues) {
                    stringsSet.add(fieldValue);
                } else {
                    stringsList.add(fieldValue);
                }
            }
        }
        return request.dedupeValues ? new List<String>(stringsSet): stringsList;
    }

    public class Request {
        @InvocableVariable(description='List of records to extract field values from' required=true)
        public List<SObject> inputRecordCollection;
        
        @InvocableVariable(description='API name of the field' required=true)
        public String fieldAPIName;

        @InvocableVariable(description='If true only unique values will be returned. The default value is true')
        public Boolean dedupeValues;
    }
    
    public class Result {
        @InvocableVariable(description='List of unique field values for API name provided')
        public List<String> fieldValueCollection;

        @InvocableVariable(description='Comma separated string of unique field values for API name provided')
        public String fieldValueString;
    }

}