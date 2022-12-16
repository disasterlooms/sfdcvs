public class QueryNRecords {
    
    /* Class definition for throwing custom exceptions */
    public class FlowApexActionException extends Exception{}
    
    @InvocableMethod(label='Query N records' description='Returns a list of N records, where is N specified by a user as a flow input.')
    public static list<QueryResults> getNrecords(QueryParameters[] queryParams){
        
        if(queryParams[0].numberOfRecords >= 50000)
            throw new FlowApexActionException('You cannot query more than 50000 records.');
        
        list<QueryResults> result = new list<QueryResults>();
        //string query = 'Select '+ queryParams[0].fieldsToQuery + ' FROM ' +  queryParams[0].objectApiName + 'WHERE Type = \'Distributor\' and FDACCOUNTID__c = null and Create_FD_Companies_Fail__c = false and VSRegion__c =\'VSA\'' +' LIMIT ' + queryParams[0].numberOfRecords;
        //string query = 'Select '+ queryParams[0].fieldsToQuery + ' FROM ' +  queryParams[0].objectApiName +queryParams[0].wherestring +' LIMIT ' + queryParams[0].numberOfRecords;
        String TypetString = 'Distributor';
        String FDACCOUNTIDString = null;
        String CreateFDCompaniesFailString = null;
        String VSRegionString = 'VSA';
        string query ='Select '+ 
            'Id, Create_FD_Companies_Fail__c, FDACCOUNTID__c, Type, VSRegion__c, Name, BillingStreet, Owner.Name, BillingCity, BillingStateCode, BillingPostalCode, BillingCountryCode, Phone, Website, VSSubRegion__c, Domain__c, Industry' + ' FROM ' + 
            'Account' +'WHERE Type = :TypetString and FDACCOUNTID__c = :FDACCOUNTIDString and Create_FD_Companies_Fail__c = false and VSRegion__c = :VSRegionString' +' LIMIT ' + '200';
        try{
            sObject[] recordList = database.query(query);
            //system.debug(recordList);
            QueryResults qr = new QueryResults();
            qr.records = recordList;
            result.add(qr);
        }catch(Exception e){
            throw e;
        }
        return result;
    }
    
    /* Input parameters for the Apex action */
    public class QueryParameters{
        @InvocableVariable(label='Api name of the Object' required = false )
        public string objectApiName;
        
        @InvocableVariable(label='API names of the fields to query(Comma separated)' required = false)
        public string fieldsToQuery;
        
        @InvocableVariable(label='Number of records to query' required = false)
        public integer numberOfRecords;
        
        @InvocableVariable(label='Where Clouse String' required = false)
        public string Wherestring;
    }
    
    /* Output parameters of the Apex action */
    public class QueryResults{
        @InvocableVariable(label='List of records')
	public sObject[] records;        
    }

}