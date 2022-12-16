global class batchFreshDeskCompanyCreate implements 
Database.Batchable<sObject>, Database.Stateful {
    
    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        //This will batch class will run on Monday Night and add assets
        //and then on tuesday morning, there will be an update on the account level
        //as a summary. 
        
        
        return Database.getQueryLocator(
            'Select id, Name,FDACCOUNTID__c,createFDCompany__c,industry,billingstatecode,billingcountrycode, '+
            'type,billingstreet,billingcity,phone  from Account where FDACCOUNTID__c = null and '+
            'createFDCompany__c = true'
        );
    }
    
    global void execute(Database.BatchableContext bc, List<Account> records){        
        
        
        for(Account a : records ){
            if(a.createFDCompany__c){
                a.createFDCompany__c = false;
                String externalUsername = 'bRZOa1KHQMZ7Mvkadg2';
                Blob credentialsBlob = Blob.valueOf(externalUsername);
                String myBase64String = EncodingUtil.base64Encode(credentialsBlob);
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setEndpoint('https://viewsonicvsasandbox.freshdesk.com/api/v2/companies');
                request.setMethod('POST');
                request.setHeader('content-type', 'application/json; charset=utf-8');
                request.setHeader('Authorization','Basic ' + myBase64String);
                ID sfId = Id.valueOf('0011H00001wjOJy');
                // Set the body as a JSON object
                request.setBody('{"name":"'+a.Name+'","custom_fields":{"sfaccountid": "'+a.Id+'"}}');
                
                HttpResponse response = http.send(request);
                system.debug('status code '+response.getStatusCode());
                system.debug(response.getBody());
                
                if(response.getStatusCode() == 201) {
                    // Deserialize the JSON string into collections of primitive data types.
                    Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                    // Cast the values in the 'animals' key as a list
                    System.debug('Received the following ids: ');
                    for (String key : results.keySet()) {
                        if(key == 'id'){
                            a.FDACCOUNTID__c = String.valueof(results.get(key));
                            system.debug(results.get(key));
                        }
                    }
                }
                
                
            }
        }
        
        
        
        update records;
    }
    
    global void finish(Database.BatchableContext bc){
        System.debug(recordsProcessed + ' records processed. disaster averted!');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
                            JobItemsProcessed,
                            TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob
                            WHERE Id = :bc.getJobId()];
        system.debug(job);
    }    
    
}