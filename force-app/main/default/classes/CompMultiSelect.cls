public class CompMultiSelect {
    @AuraEnabled
    public static List<Sobject> getRecords(String wherestmt,String limitstmt,String orderstmnt,String obj,String searchtxt,String addfields,String parentid,String prices){
        //system.debug('partners op id '+ oppid);
        // without an ID, simply specify the object to then derive the sobject type		
        system.debug('get rows');
        system.debug(searchtxt);
        system.debug(parentid);
        List<PricebookEntry> pbeLiSt = new List<PricebookEntry>();
        //Quote opp = [ SELECT id, Pricebook2Id FROM Quote WHERE id = :parentid or opportunityid =: parentid];
        if (prices == 'true') {
            set<id> prodIds = new Set<id>(); List<id> prodIdsList = new List<id>();string prodStringlits = '(';
            if(parentid.startsWith('006')){pbeLiSt = [SELECT Id, Product2Id, Product2.Name, Product2.IsActive FROM PricebookEntry WHERE Pricebook2Id in (SELECT Pricebook2Id FROM Opportunity WHERE id = :parentid) and isactive = true];
            system.debug('running opp products based on pricebook2id ');
            }else {pbeLiSt = [SELECT Id, Product2Id, Product2.Name, Product2.IsActive FROM PricebookEntry WHERE Pricebook2Id in (SELECT Pricebook2Id FROM Quote WHERE id = :parentid) ]; }  
           
            List<Product2> products = new List<Product2>();
            for (PriceBookEntry pEntry : pbeLiSt) {prodStringlits = prodStringlits + '\'' + pEntry.Product2Id + '\',';prodIdsList.add(pEntry.Product2Id);
                //prodIds.add(pEntry.Product2Id);
            }prodStringlits = prodStringlits.removeEnd(',') + ')';if (!test.isRunningTest())wherestmt = wherestmt + 'AND Id IN ' + prodStringlits;}
        system.debug('prices' + prices);
           //wherestmt = wherestmt + 'AND Id IN ' + prodIdsList;
        
        Schema.SObjectType convertType = Schema.getGlobalDescribe().get(obj);
        Sobject genericObject = convertType.newSObject();
        
        DescribeSObjectResult describeResult = genericObject.getSObjectType().getDescribe();
        
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        
        String query =		  ' SELECT ' +		      String.join( fieldNames, ',' ) + ' '+addfields+'  FROM '
            +		      describeResult.getName()	+' '+ wherestmt +' '+searchtxt+' '+orderstmnt +' '+limitstmt	;		
        // return generic list of sobjects or typecast to expected type
        
        List<SObject> records = Database.query( query );		
        System.debug( records );
        
        return records;
    }
    @AuraEnabled
    public static void createChildren(List<SObject> children,String parentId,String objToCreate,List<String> objToCreateFields){
        system.debug('child and parent');
        system.debug(children);
        system.debug(parentId);
        system.debug('obj to create '+objToCreate +' fields '+objToCreateFields);
        
        Schema.SObjectType targetType  = Schema.getGlobalDescribe().get(objToCreate);
        
        Sobject genericObject = targetType.newSObject();
        
        DescribeSObjectResult describeResult = genericObject.getSObjectType().getDescribe();
        //List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        
        String field1 ='';
        String field2 ='';
        String field3 ='';
        
        for (Integer i = 0; i < objToCreateFields.size(); i++) {
            if(i == 0){
                field1 = objToCreateFields[i];   
            }else if( i == 1){
                field2 = objToCreateFields[i];   
            }else if( i == 2){
                field3 = objToCreateFields[i];   
            }
        }
        
        system.debug(field1);
        system.debug(field2);
        system.debug(field3);
        system.debug('fields');
        List<SObject> recordsToInsert = new List<SObject>();
        for(SObject s : children){
            system.debug(s.Id);
            sObject sobj = Schema.getGlobalDescribe().get(objToCreate).newSObject() ;
            
            sobj.put(field1, parentId);            
            sobj.put(field2, s.Id);
            if(field3 != null && field3 != ''){
                sobj.put(field3, s.Id);
            }
            
            
            recordsToInsert.add(sobj);
            
        }
        
        
        insert recordsToInsert;
        
    }
    
}