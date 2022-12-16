public without sharing class batchAccountFDCompany implements Queueable, Database.AllowsCallouts  {  
    Set<Id> records = new Set<Id>();
    @testVisible
    private static Boolean doChainJob = true;
    public batchAccountFDCompany(Set<Id> records) {  
        
        this.records = records;  
    }    
    public void execute(QueueableContext qc) { 
        
        List<Account> accts = [Select id, Name,FDACCOUNTID__c,createFDCompany__c,vsregion__c,
                               industry,billingstatecode,billingcountrycode,domain__c,billingcountry,
                               billingpostalcode,type,VSSubRegion__c,billingstate,
                               billingstreet,billingcity 
                               from Account where Id in : records];
        for(Account a : accts ){
            if(a.createFDCompany__c){
                
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
                String domains = '';
                String street = '';
                String city = '';
                String state = '';
                String postal = '';
                String country = '';
                String subregion = '';
                String region = '';
                
                if(a.Domain__c != null){
                    domains = a.Domain__c.deleteWhitespace();
				}
                if(a.billingstreet != null){
                    street = a.billingstreet;
				}
                if(a.billingcity != null){
                    city = a.billingcity;
				}
                if(a.billingstate != null){
                    state = a.billingstate;
				}
                if(a.billingpostalcode != null){
                    postal = a.billingpostalcode;
				}
                if(a.billingcountry != null){
                    country = a.billingcountry;
				}
                if(a.vsregion__c != null){
                    region = a.vsregion__c;
				}
                if(a.VSSubRegion__c != null){
                    subregion = a.VSSubRegion__c;
				}
                 
                
                String jsnBody = '{"name":"'+a.Name+'","domains": ["'+a.Domain__c+'"],"custom_fields":{"sfaccountid": "'+a.Id+'",'+
                                '"street": "'+street+'","city": "'+city+'","state": "'+state+'",'+
                                '"postalcode": "'+postal+'","country": "'+country+'","region": "'+region+'",'+
                                '"subregion": "'+subregion +'"}}';
                   system.debug(jsnBody);
                   request.setBody(jsnBody );
                
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
                            a.createFDCompany__c = false;
                            system.debug(results.get(key));
                        }
                    }
                }else{                    
                    a.fdErrorCompany__c = response.getBody();
				}
            }
        }
        
        update accts;
    }
    
}