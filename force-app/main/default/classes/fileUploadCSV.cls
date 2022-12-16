public without sharing class fileUploadCSV {
    @AuraEnabled
    public static list<Asset> serials(Id contentDocumentId){
        List<Asset> records = new List<Asset>();
        
        Set<String> spiffName = new Set <String>();
        List<String> serials = new List <String>();

        Map<String,Spiff_Request__c> spiffMap = new Map<String,Spiff_Request__c>();
        Map<String,Asset> assMap = new Map<String,Asset>(); 

        //get VS Account Id
        Id vs = [Select id from Account where name like 'ViewSonic Corp%'
        and billingcountry = 'United States' limit 1].id;        
        
        if(contentDocumentId != null){  
            ContentVersion contentVersionObj = [SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId =:contentDocumentId];
            list<String> csvRecordsList = contentVersionObj.VersionData.toString().split('\n');          
            
           //put the serials and the spiffs in separte lists to create a map for 
           //serials and spiffs 
            for(Integer i = 1; i < csvRecordsList.size(); i++){
                list<String> csvRowData = csvRecordsList[i].split(',');
                serials.add(csvRowData[0].trim());
                spiffName.add(csvRowData[1].trim());
            }
            system.debug('spiff names ');
            system.debug(spiffName);
            for(Asset a : [Select id,AccountId,PurchaseDate,serialnumber, spiff_request__r.name,name,SerialLine__c,spiff_request__c
                       from Asset where serialnumber in : serials ])
            assMap.put(a.serialnumber,a);
        
            for(Spiff_Request__c a : [Select id,name,Sale_Date__c, End_User__c,Requester__c,Requester__r.AccountId from spiff_request__c 
                                  where name in : spiffName])
            spiffMap.put(a.Name,a);
            
            system.debug('spiff records found and size ');
            system.debug(spiffMap);
            system.debug(spiffMap.size());

            system.debug('asset records found and size');
            system.debug(assMap);
            system.debug(assMap.size());

            for(Integer i = 1; i < csvRecordsList.size(); i++){        
                //split the columns to get the serial number        
                list<String> csvRowData = csvRecordsList[i].split(',');                
                //ass is the New Asset or the Existing asset to be added to the serial 
                //list for upsert
                Asset ass = new Asset();  
                Spiff_Request__c spiff = new Spiff_request__c();
                try{
                    spiff = spiffMap.get(csvRowData[1].trim()); 
                    if(assMap.containsKey(csvRowData[0].trim())){                 
                        ass = assMap.get(csvRowData[0].trim());
                        if(ass.spiff_request__c != null){
                            ass.Notes__c = 'Error: Serial Already Claimed '+ ass.Spiff_Request__r.Name;
                            ass.Spiff_Name__c = ass.Spiff_Request__r.Name;
                        }else{
                            ass.Spiff_request__c = spiff.Id;
                            ass.Spiff_Name__c = spiff.Name;

                        }
    
                        if(ass.PurchaseDate == null){
                            //if no purchase date in serial, then use the spiff sale date
                            ass.PurchaseDate = spiff.Sale_Date__c;
                        }
                        if(ass.accountid == vs && spiff.End_User__c != null){
                            ass.accountId = spiff.End_User__c;
                        }
                        ass.Reseller_Account__c = spiff.Requester__r.AccountId;
                        //this is if there is no existing serial create a new serial
                    }else{
                        ass.Spiff_request__c = spiff.Id;
                        ass.Spiff_Name__c = ass.Spiff_Request__r.Name;
                        ass.accountId = spiff.End_User__c;
                        ass.Reseller_Account__c = spiff.Requester__r.AccountId;
                        ass.PurchaseDate = spiff.Sale_Date__c;
                        ass.serialNumber = csvRowData[0];
                        ass.Name = csvRowData[0];
                        ass.Serialline__c =   csvRowData[0];
                    }                
                
                }catch(Exception e){
                    if(assMap.containsKey(csvRowData[0])){
                        ass.Spiff_Name__c = null;         
                        ass = assMap.get(csvRowData[0]);
                        ass.Notes__c = 'Serial Exists but the Spiff Request Name '+csvRowData[1]+' was not found. '+
                        'Make sure the spiff request number is correct';
                    }else{
                        ass.Spiff_Name__c = null;     
                        ass.serialNumber = csvRowData[0];
                        ass.Name = csvRowData[0];
                        ass.Serialline__c =   csvRowData[0];
                        ass.AccountId = vs;
                        ass.Notes__c = 'Serial Exists but the Spiff Request Name '+csvRowData[1]+' was not found. '+
                        'Make sure the spiff request number is correct';
                    }                    
                    
                    

                }

               records.add(ass); 
            }
        
        }else{
            throw new AuraHandledException('There was a problem retrieving the file and its id, '+
            ' please try again and if the problem persists, open a ticket with help desk ');
        }
        return records;
    }

    @AuraEnabled
    public static list<Asset> fromSpiff(Id contentDocumentId, String recordId){
        List<Asset> records = new List<Asset>();
        
        Map<String,Asset> assMap = new Map<String,Asset>();     
        List<String> serials = new List<String>();
        Spiff_Request__c  spiff = new Spiff_Request__c();
        try{
            spiff = [Select id,name,Sale_Date__c, End_User__c,Requester__c,Requester__r.AccountId from spiff_request__c 
                     where id =: recordId limit 1];
        }Catch(Exception ex){
            throw new AuraHandledException('The Spiff Id Was not found, '+
            'please notify amdin of this error via help desk ticket '
            +ex.getMessage());           
            
        }
        // After getting vaules from spiff, some spiffs do not have end user and 
        //there must be an account or asset will get an error. We are going to 
        //put the Account as ViewSonic in this Case
        //
        String acctId = spiff.End_User__c;
        Id vs = [Select id from Account where name like 'ViewSonic Corp%'
        and billingcountry = 'United States' limit 1].id;        
        if(spiff.End_User__c == null){
            acctId = vs;
        }

        // Fetch File Data based on the basic of document id 
        if(contentDocumentId != null && recordId!= null) {
            system.debug('Record id spiff is located');
            // Fetch File Data based on the basic of document id 
            ContentVersion contentVersionObj = [SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId =:contentDocumentId];
            // split the file data
            list<String> csvRecordsList = contentVersionObj.VersionData.toString().split('\n');
            // get the assets that exists already by serial numbers, there can be an update
            //but the spiff request cannot change and need to let the user uploading know 
            //that some of the imported serial numbers already exist for a different spiff request
            
            for(Integer i = 1; i < csvRecordsList.size(); i++){
                list<String> csvRowData = csvRecordsList[i].split(',');
                serials.add(csvRowData[0].trim());                
            }
            for(Asset a : [Select id,PurchaseDate,AccountId,serialnumber, spiff_request__r.name,name,SerialLine__c,spiff_request__c
                           from Asset where serialnumber in : serials ])
                assMap.put(a.serialnumber,a);

            //check if we got asset ids from some records
            system.debug(assMap.size());
            system.debug(assMap);
            system.debug('size of serial map and sample record ');
            for(Integer i = 1; i < csvRecordsList.size(); i++){        
                //split the columns to get the serial number        
                list<String> csvRowData = csvRecordsList[i].split(',');                
                //ass is the New Asset or the Existing asset to be added to the serial 
                //list for upsert

                Asset ass = new Asset();  

                if(assMap.containsKey(csvRowData[0].trim())){                    
                    ass = assMap.get(csvRowData[0].trim());
                    if(ass.spiff_request__c != null){
                        ass.Notes__c = 'Error: Serial Already Claimed '+ ass.Spiff_Request__r.Name;
                        ass.Spiff_Name__c = ass.Spiff_Request__r.Name;
                    }else{
                        ass.Spiff_request__c = spiff.Id;
                        ass.Spiff_Name__c = spiff.Name;
                    }

                    if(ass.PurchaseDate == null){
                        //if no purchase date in serial, then use the spiff sale date
                        ass.PurchaseDate = spiff.Sale_Date__c;
                    }
                    if(ass.accountid == vs && spiff.End_User__c != null){
                        ass.accountId = spiff.End_User__c;
                    }
                    ass.Reseller_Account__c = spiff.Requester__r.AccountId;
                    //this is if there is no existing serial create a new serial
                }else{
                    ass.Spiff_request__c = spiff.Id;
                    ass.Spiff_Name__c = ass.Spiff_Request__r.Name;
                    ass.accountId = spiff.End_User__c;
                    ass.Reseller_Account__c = spiff.Requester__r.AccountId;
                    ass.PurchaseDate = spiff.Sale_Date__c;
                    ass.serialNumber = csvRowData[0];
                    ass.Name = csvRowData[0];
                    ass.Serialline__c =   csvRowData[0];
                }
                records.add(ass); 
            }
        }else{
            throw new AuraHandledException('There was a problem retrieving the file and its id, '+
            ' please try again and if the problem persists, open a ticket with help desk ');
        }

        return records;


    }    
    @AuraEnabled
    public static list<Asset> csvFileRead(Id contentDocumentId, String recordId){
        //test
        List<Asset> assetsInsertList = new List<Asset>();

        if(recordId!= null) {
            assetsInsertList = fileUploadCSV.fromSpiff(contentDocumentId,recordId);

        }else{
            assetsInsertList = fileUploadCSV.serials(contentDocumentId);
        }    
            
            try{    
                if(!assetsInsertList.isEmpty()) {
                    upsert assetsInsertList;
                }
            }
            catch (Exception ex) {
                system.debug('assetsInsertList failure');
                throw new AuraHandledException(ex.getMessage());
            }
        return assetsInsertList;    
    }
}