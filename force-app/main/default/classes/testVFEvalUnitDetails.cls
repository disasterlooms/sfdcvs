@isTest
private class testVFEvalUnitDetails {
@testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
       
    static testmethod void getOppPartners() {		
       User u = [SELECT Id, Manager.Contact_ID__c,Contact_ID__c,managerId FROM User WHERE Id= :UserInfo.getUserId() Limit 1] ;
        contact o = [Select Id, UserId__c from Contact where UserId__c = :UserInfo.getUserId() limit 1];
        Account a = [Select Id, Name,Type,billingstate from Account where name ='ZZpbest' limit 1];
        
        Contact con = new Contact(FirstName='Random',LastName='ApexTest',
                                  email='apextest3@apexmail.com', phone='9995557865',
                                  AccountId=a.id,MailingStatecode='CA',
                                 mailingcountrycode='US');
        insert con;
        
        system.debug('user conid '+u.Contact_ID__c);
        
        test.startTest();
        Eval_Request__c ev = new Eval_Request__c(
            Expected_Receive_Date__c= date.today(),
            Evaluation_Owner__c = o.Id,
            Eval_Type__c = 'End-User/Reseller/Disty Eval'
            
        ); 
        insert ev;
        
        
        vfEvalUnitDetails cont = new vfEvalUnitDetails();
        cont.eId = ev.Id;
        system.debug('eval id '+ev.Id);
        cont.squery = 'Select id, sku__r.name,name,status__c from eval_unit_details__c where eval_Request__c =:';
        List<Eval_Unit_Details__c> eud = cont.getrecords();
        

  }

}