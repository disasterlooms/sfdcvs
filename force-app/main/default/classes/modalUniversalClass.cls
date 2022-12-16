public without sharing class modalUniversalClass {
    @auraEnabled
    public static Modal_Settings__c  getModalSetting(String parentFields,String whereStatement,
                                                     String orderStatement,String limitStatement, String modalName){
        
        List<Modal_Settings__c> records = new List<Modal_Settings__c>();
        
        User u = [Select id from User where id = : UserInfo.getUserId() limit 1];
        String currentUser = u.Id;
        /*                                                 
        Modal_Settings__c ms1 = [Select id, user__c,modal__r.name from Modal_Settings__c limit 1];
        system.debug(ms1);
        system.debug('the modal seettgin info');
        */                                                 
        Schema.SObjectType convertType = Schema.getGlobalDescribe().get('Modal_Settings__c');
        Sobject genericObject = convertType.newSObject();
        
        DescribeSObjectResult describeResult = genericObject.getSObjectType().getDescribe();
        
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        
        String query =		  ' SELECT ' +		      String.join( fieldNames, ',' ) +' '+ parentFields + '  FROM '
            +		      describeResult.getName()	+' where Modal__r.Name = : modalName and Modal__r.isActive__c = true and User__c = : currentUser ' + whereStatement + ' '+ orderStatement+' '+ limitStatement;	
         Modal_Settings__c ms = null;
                                                         system.debug('query');
                                                         system.debug(query);
       	  try{
            records = Database.query( query );
            ms =   records[0];
        }catch(exception e){            
            String t = 'Error on the Modal '+ modalName + ' User '+UserInfo.getUserName();
            ms = null;
            system.debug('error ');
            system.debug(e);
            system.debug(t);
            //AdminErrorMessage.SendError(e, t);
        }   
        return ms;
    }
    @auraEnabled
    public static Modal_Settings__c  updateSetting(Modal_Settings__c mset,String action,Boolean remove){
        mset.Last_Date_Shown__c = date.today();
        mset.Never_Show__c = remove;
        if(action == 'click'){
            mset.Times_Clicked__c =  mset.Times_Clicked__c +1;
        }else{
            mset.Times_Dismissed__c  =  mset.Times_Dismissed__c +1;
        }
        update mset;
        
        return mset;
                                                         
                                                         
                                                         
  }

}