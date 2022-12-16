public without sharing class createFreshDeskTicket {
    @AuraEnabled(cacheable=false)
    public static String updateTicket(String description) {
        String imageRichText = description;
        system.debug('old description '); 
        system.debug(description);   
        Matcher imgMatcher = Pattern.compile( '<img(.+?)>' ).matcher(imageRichText);
        String img = '';
        string strFolderId = [SELECT Id FROM Folder where type = 'Document' and IsReadonly = false limit 1].Id;
        String newDescription = '';
        List<Document> docs =  new List <Document>();
        Integer counter = -1;
        while (imgMatcher.find()){ 
            counter = counter+1;             
            String imageTag = imgMatcher.group();
            img = imageTag.substringBetween(' src="', '"' );
            //System.debug('img ===>' + img);
            String container = '';
            container = img;
            PageReference pageRef = new PageReference(container);
            Document doc = new Document();
            doc.Name = 'pic1';
            doc.Type = 'png';
            doc.folderId = strFolderId;
            doc.Description = img;
            if(!test.isRunningTest()){
                doc.Body = pageRef.getContent();
            }else{
                doc.Body =  Blob.valueOf('zyx');
            }
            
            doc.isPublic = true;
            docs.add(doc);
            
        } 
        insert docs;
        system.debug(docs);
        system.debug(docs.size()+' doc list size');
        Organization org =  [SELECT id,name,isSandbox FROM Organization LIMIT 1];
        Boolean sandbox = org.isSandbox; 
        String imgBaseURL = 'https://viewsonic--fullsand--c.documentforce.com/';
        if(!sandbox){
          imgBaseURL =  'https://viewsonic--c.na160.content.force.com/';
        }
        for(Document dc : docs){
            system.debug('descrip');
            system.debug(dc.description);
            system.debug(dc.id);
            String newURL = imgBaseURL+'servlet/servlet.ImageServer?id='+dc.Id+'&oid='+UserInfo.getOrganizationId();
            system.debug(dc.Id);
            system.debug('servlet/servlet.ImageServer?id='+dc.Id+'&oid='+UserInfo.getOrganizationId());
            description = description.replace(dc.description,newURL);
        }

        system.debug('new description '); 
        system.debug(description);           
        return description;

    }
    @AuraEnabled(cacheable=false)
    public static String createTicket(String email, String name,String acctId, String subject,String description,String fdgroup,Boolean addemails) {
        system.debug('email '+subject);
        system.debug('group '+fdgroup);
        Organization org =  [SELECT id,name,isSandbox FROM Organization LIMIT 1];
        system.debug(org);
        Boolean sandbox = org.isSandbox; 
        CalloutKey__mdt ck = [Select id, API_Key__c, Custom_Field_1__c,
                              Custom_Field_2__c,Sandbox__c,url__c from CalloutKey__mdt 
                              where Sandbox__c =: sandbox and 
                              label = 'FreshDesk' limit 1 ];
        
        User u = [Select id, name, email from user where id =: UserInfo.getuserId()];
        FD_Groups__c fdGroupid =  [Select id, groupId__c from FD_Groups__c where isSandbox__c = : sandbox and groupName__c =: fdgroup limit 1];
        system.debug('id '+fdGroupid.groupId__c);
        system.debug(ck);
        String externalUsername = ck.API_Key__c;
        system.debug('url '+ck.url__c);
        String adduseremail = '';
        if(addemails){
            adduseremail = '"'+u.Email+'"';
        }
        system.debug('add email? '+ addemails+' '+adduseremail);
        Account a = [Select id, name, billingstate,billingcountry,billingcountrycode,
                     VSRegion__c ,VSSubRegion__c,FDACCOUNTID__c  from account where id =: acctId];
        String region = 'Other';
        String state = 'Other';
        if(a.billingcountry == 'Canada'){
            region = 'Canada';
            if(a.billingstate != null){
                state = a.billingstate;
            }
            
        }else if(a.billingcountry == 'United States'){
            region = 'USA';
            if(a.billingstate != null){
                state = a.billingstate;
            }
        }
        
// Step 1:  Creating Ticket Step 1
        String calloutInfo = '';
        Blob credentialsBlob = Blob.valueOf(externalUsername);
        String myBase64String = EncodingUtil.base64Encode(credentialsBlob);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(ck.url__c+'tickets/');
        request.setMethod('POST');
        request.setHeader('content-type', 'application/json; charset=utf-8');
        request.setHeader('Authorization','Basic ' + myBase64String);
        String ticketBody = '{"email": "'+email+'",'+
            '"status": 2,"group_id": '+fdGroupid.groupId__c+','+
            '"priority": 1,"source": '+ck.Custom_Field_2__c+','+
            '"cc_emails": ['+adduseremail+'],"subject": "'+subject+'",'+
            '"description": "'+description+'",'+
            '"type": "General",'+
            '"custom_fields": {'+
            '"cf_region": "'+region+'",'+
            '"cf_stateprovincecountry": "'+state+'",'+
            '"cf_resolution": "Customer Support",'+
            '"cf_model_name": "",'+
            '"cf_ts_sub_type": "",'+
            '"cf_os_version": "Other",'+
            '"cf_firmware_version": "",'+
            '"cf_serial_number": "",'+
            '"cf_product_type": "Other"},'+
            '"tags": ["SalesforceAPI"]}';
        request.setBody(ticketBody);
        system.debug(ticketBody);
        HttpResponse response = new HttpResponse();
        if(test.isRunningTest()){
            response = VSMockHttpResponseGenerator.respond(request);
        }else{
            response = http.send(request);
        }
        
        
        
        system.debug('status code '+response.getStatusCode());
        system.debug(response.getBody());
        calloutInfo = response.getBody();
        
        String ticketId = '';
// Step 1B Checking if there is a callout response error on creating ticket 
        if(response.getStatusCode() != 201 &&
           response.getStatusCode() != 200){
               calloutInfo = 'Error';
               String ername = 'createFreshDeskTicket '+userinfo.getuserName();
               String cmp = 'createFreshDeskTicket line 60';
               String userid = userinfo.getuserid();
               String errmssg =  response.getBody();
               String recordId = '';
               String calloutBody = ticketBody;
               String recordname = '';
               String objType = '';
               createComponentErrorLog.createComponentErrorLog(ername, cmp, userid, errmssg, recordId,calloutBody, objType, acctId,recordname);           
           }else{
               Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
               
               System.debug('Received the following ids: ');
               for (String key : results.keySet()) {
                   if(key == 'id'){
                       ticketId = String.valueof(results.get(key));
                       system.debug(String.valueof(results.get(key)));
                       system.debug('got the response');
                   }
               }
               //User u = [Select id, name, email from user where id =: UserInfo.getuserId()];
               
//Step 2: Get the contact data from freshdesk via callout

               if(a.FDACCOUNTID__c != null){
                   String encodedURL = EncodingUtil.urlEncode(email, 'UTF-8'); 
                   HttpRequest reqContact = new HttpRequest(); 
                   reqContact.setEndpoint('https://viewsonicvsasandbox.freshdesk.com/api/v2/contacts?email='+encodedURL);
                   reqContact.setMethod('GET');
                   reqContact.setHeader('content-type', 'application/json; charset=utf-8');
                   reqContact.setHeader('Authorization','Basic ' + myBase64String);
                   String fduserId = '';
                   
                   HttpResponse getContactid = new HttpResponse();
//checking if test and need a mock callout
                   if(test.isRunningTest()){
                       
                       getContactid = VSMockHttpResponseGenerator.respondArray(reqContact);
                   }else{
                       getContactid = http.send(reqContact);
                   }
                   
                   system.debug(getContactid.getBody());
// Step 2B Checking if there is a callout response error on getting contact info 

                   
                   try{
                       List<Object> fieldList2 = (List<Object>)JSON.deserializeUntyped(getContactid.getBody()); 
                            for(Object fld : fieldList2){    
                                system.debug(fld);
                                Map<String, Object> data = (Map<String, Object>)fld;
                                system.debug('the data? '+data.get('id'));
                                fduserId = String.valueof(data.get('id'));
                            }
                        }catch(Exception e){
                            Map<String, Object> fieldList1 = (Map<String, Object>) JSON.deserializeUntyped(getContactid.getBody());
                            
                            System.debug('Received the following ids: ');
                            for (String key : fieldList1.keySet()) {
                                if(key == 'id'){
                                    fduserId = String.valueof(results.get(key));
                                    system.debug(String.valueof(results.get(key)));
                                    system.debug('got the response');
                                }
                            }                            
                        }
                  
                  
                   
                   /*
                    Map<String, Object> fieldList1 = (Map<String, Object>) JSON.deserializeUntyped(getContactid.getBody());
                    
                    System.debug('Received the following ids: ');
                    for (String key : fieldList1.keySet()) {
                    if(key == 'id'){
                    fduserId = String.valueof(results.get(key));
                    system.debug(String.valueof(results.get(key)));
                    system.debug('got the response');
                    }
                    }
                    */

//Step 3 : Get the Fresh Desk Company Id from Salesforce and Add to the Fresh
//Desk Contact. the id is a number and needs to be used as a Long primitive type                   
                   
                   Long L1 = long.valueOf(a.FDACCOUNTID__c);
                   request.setEndpoint('https://viewsonicvsasandbox.freshdesk.com/api/v2/contacts/'+fduserId);
                   request.setMethod('PUT');
                   request.setBody('{"company_id" : '+L1+'}');
                   
                   HttpResponse updateresponse = new HttpResponse();
                   if(test.isRunningTest()){
                       updateresponse = VSMockHttpResponseGenerator.respond(request);
                   }else{
                       updateresponse = http.send(request);
                   }
                   
                   system.debug('status code for Company Update'+updateresponse.getStatusCode());
                   system.debug(updateresponse.getBody()); 
               }
               
//Step 4:  Update ticket Notes and if an error send to error log for investigation
               
               request.setEndpoint(ck.url__c+'tickets/'+ticketId+'/notes');
               request.setBody('{ "body":"This ticket was created by a ViewSonic sales rep for the customer via Salesforce. SalesRep Name is '+u.Name+'", "private" : false }');
               request.setMethod('POST');
               
               HttpResponse responseNote = new HttpResponse();
               if(test.isRunningTest()){
                   responseNote = VSMockHttpResponseGenerator.respond(request);
               }else{
                   responseNote = http.send(request);
               }
               
               
               system.debug(responseNote.getStatusCode());
               if(responseNote.getStatusCode() != 201 &&
                  responseNote.getStatusCode() != 200 || test.isRunningTest()){
                      String ername = 'createFreshDeskTicket '+u.Name;
                      String cmp = 'createFreshDeskTicket line 145';
                      String userid = userinfo.getuserid();
                      String errmssg =  responseNote.getBody();
                      String recordId = '';
                      String calloutBody = '{ "body":"This ticket was created by a ViewSonic sales rep for the customer via Salesforce. SalesRep Name is '+u.Name+'", "private" : true }';
                      String recordname = 'endpoint '+ck.url__c+'tickets/'+ticketId+'/notes';
                      String objType = '';
                      createComponentErrorLog.createComponentErrorLog(ername, cmp, userid, errmssg, recordId, calloutBody, objType, acctId,recordname);           
                  }else{
                      system.debug('Note was successful');
                  }
               
           }
        
        return calloutInfo;
        
    }
    
    @AuraEnabled(cacheable=true)
    public static CalloutKey__mdt getFreshDeskCredentials() {
	    return [Select id, API_Key__c, Custom_Field_1__c, Custom_Field_2__c,Sandbox__c,url__c from CalloutKey__mdt where Sandbox__c =: [SELECT id,name,isSandbox FROM Organization LIMIT 1].isSandbox and label = 'FreshDesk' limit 1 ];
    }

}