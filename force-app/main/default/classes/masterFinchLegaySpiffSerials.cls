public class masterFinchLegaySpiffSerials{
    // These variables store Trigger.oldMap and Trigger.newMap
    Map<Id, finchLegacySerialNumbers__c > oldspiffs;
    Map<Id, finchLegacySerialNumbers__c > newspiffs;
    
    
    public masterFinchLegaySpiffSerials(
        Map<Id, finchLegacySerialNumbers__c > oldTriggerspiffs, 
        Map<Id, finchLegacySerialNumbers__c > newTriggerspiffs) {
            oldspiffs = oldTriggerspiffs;
            newspiffs = newTriggerspiffs;
        }
    
    public static void assetUpdate(List<finchLegacySerialNumbers__c> records) {
        List<Asset> assetsToUpdate = new List<Asset>();
        
        Set<String> legacy = new Set<String> ();
        Set<String> serials = new Set<String> ();
        
        for(finchLegacySerialNumbers__c fs : records){
            if(fs.legacySpiffId__c != null & fs.SerialNumber__c != null){
                legacy.add(fs.legacySpiffId__c);
                serials.add(fs.SerialNumber__c);
            }
            
        }
        
        Map<String,Asset> sales = new Map<String,Asset>();        
        Map<String,Spiff_Request__c> spiffs = new Map<String,Spiff_Request__c>();
        
        for(Asset a : [Select id,Spiff_Request__c,serialnumber,AccountId,ContactId from Asset where serialnumber in : serials  ]){
            sales.put(a.SerialNumber,a);
        }
        
        List<finchLegacySerialNumbers__c> noSerial = new List<finchLegacySerialNumbers__c>();
        for(Spiff_Request__c s : [Select id, Legacy_Spiff_Claim_Id__c,Requester__c  from Spiff_Request__c where Legacy_Spiff_Claim_Id__c  in: legacy ]){
            spiffs.put(s.Legacy_Spiff_Claim_Id__c , s);
        }        
        List<Account> vs = [Select id, name from account where name = 'ViewSonic Corporation' limit 1];
        for(finchLegacySerialNumbers__c f : records){
            if(sales.containsKey(f.SerialNumber__c )){
                if(spiffs.containsKey(f.legacySpiffId__c )){
                    Spiff_Request__c s = spiffs.get(f.legacySpiffId__c);
                    Asset a = sales.get(f.SerialNumber__c);
                    f.Spiff_Request__c = s.Id;
                    f.SerialAsset__c = a.Id;
                    String acctId='';
                    String conId ='';
                    if(a.AccountId == null){
                        acctId = vs[0].Id;
                    }else{
					acctId = a.AccountId;                    
                    }
                    if(a.ContactId == null){
                        conid = s.Requester__c;
                    }else{
                        conid = a.ContactId; 
                    }
                    Asset ass = new Asset();
                    ass.AccountId = acctId;
                    ass.ContactId = conid;
                    ass.Id = a.Id;
                    ass.Spiff_Request__c = s.Id;
                    assetsToUpdate.add(ass);
                }
                
            }else{
                noSerial.add(f);
            }
            
        }
        //prevent the asset update from running in this narrow use case
        TriggerContextUtility.setFirstRunFalse();
        database.SaveResult [] srList  = database.update (assetsToUpdate,false);
        List<Apex_Error_Message__c> errorToCreate = new List<Apex_Error_Message__c>();
        for(Database.SaveResult sr : srList) {
            if (!sr.isSuccess()) {
                for(Database.Error err : sr.getErrors()) {
                    Apex_Error_Message__c er = new Apex_Error_Message__c ();
                    er.Apex_Class__c = 'masterFinchLegaySpiffSerials';
                    er.Error_Message__c = err.getStatusCode() + ' : ' + err.getMessage();
                    er.ObjectType__c = 'Asset';
                    er.recordId__c = sr.getId();
                    errorToCreate.add(er); 
                        }
                
               
            }
        }
        insert errorToCreate;
        queueAddSerialNumber rTr = new queueAddSerialNumber(noSerial);
        if(noSerial.size()> 0){
            System.enqueueJob(rTr);
        }
        
        
    }
    
}