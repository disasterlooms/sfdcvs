public without sharing class freshDeskTicket {
    @AuraEnabled
    public static String getTicketData(String ticketId) {
        //get ticket from freshdesk
        system.debug('tik id '+ ticketId);
        CalloutKey__mdt keyObj =  [select id,url__c ,label,API_Key__c  from CalloutKey__mdt
                                     where developername = 'Fresh_Desk' and Sandbox__c = false limit 1];

       
        String externalUsername = keyObj.API_Key__c;
        Blob credentialsBlob = Blob.valueOf(externalUsername);
        String myBase64String = EncodingUtil.base64Encode(credentialsBlob);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = keyObj.url__c+'tickets/'+ticketId+'/conversations';
        system.debug('endpoint '+endpoint);
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        request.setHeader('content-type', 'application/json.');
        request.setHeader('Authorization','Basic ' + myBase64String);
        
        
        String result = ''; 
        HttpResponse response = new HttpResponse();
        
        String calloutInfo = '';
        //HttpResponse response = http.send(request);
        if(!Test.isRunningTest()){
            response = http.send(request);
            System.debug('response:--> ' + response.getBody());
            result = response.getBody();

        }else{
            response = VSMockHttpResponseGenerator.respond(request);
        }

        if((response.getStatusCode() != 201 &&
           response.getStatusCode() != 200) || test.isRunningTest()){
            calloutInfo = 'Error';
            String ername = 'createFreshDeskTicket '+userinfo.getuserName();
            String cmp = 'createFreshDeskTicket line 60';
            String userid = userinfo.getuserid();
            String errmssg =  response.getBody();
            String recordId = '';
            String calloutBody = '';
            String recordname = '';
            String objType = '';
            String acctId = null;
            createComponentErrorLog.createComponentErrorLog(ername, cmp, userid, errmssg, recordId,calloutBody, objType, acctId,recordname);           
            if(!test.isRunningTest()){
                throw new AuraHandledException('Something went wrong. SFDC team notified and will reach out shortly. http response code ' + response.getStatusCode()+' Response body (if applicable:) '+response.getBody()); 
            }
            
            //result = 'Something went wrong. SFDC team notified and will reach out shortly.';
           }
        
        system.debug(result);
        system.debug(response.getStatusCode());
        
        return result;
    }
}