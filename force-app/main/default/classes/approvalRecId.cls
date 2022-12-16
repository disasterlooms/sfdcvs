public with sharing class approvalRecId {
        @AuraEnabled
        public static String getRecId(String recordId){
            String recidsub = recordId.substring(0,3);
            ProcessInstance sob = new ProcessInstance();
            
                if(recidsub == '04h'){
                    try{
                    sob = [SELECT id,TargetObjectId FROM ProcessInstance 
                       where id in 
                       (SELECT ProcessInstanceId FROM ProcessInstanceStep where id =: recordId)];}catch(Exception e){}
                }else{
                    try{sob = [SELECT id,TargetObjectId FROM ProcessInstance 
                       where id in 
                       (SELECT ProcessInstanceId FROM ProcessInstanceWorkitem where id =: recordId)];}catch(Exception e){}
                }
                
            
            String recid = sob.TargetObjectId;       
            
            
            return recid;
            
        }
        @AuraEnabled
        public static SObject getRecordDetail(Id recordId,String fieldNames,String ObjName){
            
            String query =		  ' SELECT ' +		       fieldNames+	  ' FROM '+ObjName+
                +		     ' WHERE Id = : recordId  limit 1';		
            // return generic list of sobjects or typecast to expected type
            
            SObject records = Database.query( query );		
            
            system.debug('records');
            system.debug(records);
            system.debug(query);     
            return records;
            
        }
    }