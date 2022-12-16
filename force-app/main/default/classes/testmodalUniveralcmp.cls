@isTest
public class testmodalUniveralcmp {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    
    Static testmethod void modalUniversal () {
        
        test.startTest();
        
        List<Modal_Settings__c> records = new List<Modal_Settings__c>();
        Schema.SObjectType convertType = Schema.getGlobalDescribe().get('Modal_Settings__c');
        Sobject genericObject = convertType.newSObject();
        
        DescribeSObjectResult describeResult = genericObject.getSObjectType().getDescribe();
        
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        
        String query =		  ' SELECT ' +		      String.join( fieldNames, ',' ) +'   FROM '
            +		      describeResult.getName()	+' limit 1';	
        
        records = Database.query( query );
        Modal_Settings__c ms = records[0];
        
        //Modal_Settings__c ms = [Select id, User__c,Times_Clicked__c from Modal_Settings__c limit 1];
        
        
        
        
        
        ms.User__c = UserInfo.getUserId();
        update ms;
        
        Modal__c md = [Select id from Modal__c  where name = 'test modal'];
               
        
        
        String parentFields = ',Modal__r.Name,User__r.Name';
        String whereStatement = ' and Never_Show__c = false';
        String orderStatement = 'order by Last_Date_Shown__c asc';
        String limitStatement = 'Limit 1';
        String modalName = 'test modal';
		String action = 'click';
		Boolean remove = true;
        
        Modal_Settings__c mset = modalUniversalClass.getModalSetting(parentFields, whereStatement, orderStatement, limitStatement, modalName);
        
        Modal_Settings__c mset2 = modalUniversalClass.updateSetting(ms,action,remove);
        
        delete md;
        
        Modal_Settings__c mset3 = modalUniversalClass.getModalSetting(parentFields, whereStatement, orderStatement, limitStatement, modalName);
        
       
        
        //modalUniversalClass.getModalSetting(parentFields, whereStatement, orderStatement, limitStatement, modalName);
        
        test.stopTest();
        
        system.assertEquals(mset.Modal__r.Name, modalName);
        system.assertEquals(mset2.Times_Clicked__c, 1);
        system.assertEquals(mset2.Never_Show__c, true);
        system.assertEquals(mset3, null);
        
        system.debug('test mod name '+ mset.Modal__r.Name);
        
    }    
    
}