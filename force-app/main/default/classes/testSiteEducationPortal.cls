@IsTest
public class testSiteEducationPortal {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords(); 
    }
    Static testmethod void testgetAccount() {
        test.startTest();
        Account a = [Select id from account limit 1];
        system.debug('returned account');
        system.debug(a);
        CustomerKeys__mdt k = [SELECT key__c  FROM CustomerKeys__mdt  limit 1];
        Blob data = Blob.valueOf(a.Id);
        Blob key = Blob.valueOf(k.key__c);        
        system.debug(k.key__c);
        Blob encryptedData = Crypto.encryptWithManagedIV('AES128',key, data);
        String b64 = EncodingUtil.base64Encode(encryptedData);
        Account retAcct = EducationRegLight.getAccount(b64);
        system.debug(' encoded for url '+b64);
        Test.stopTest();
        String sendValue = a.Id;
        String retValue = retAcct.Id;
        Boolean result = sendValue.equals(retValue);
        
        system.assertEquals(true,result);
        
    }
    Static testmethod void getContacts() {
        test.startTest();
        Account a = [Select id from account limit 1];
        EducationRegLight.getContacts(a.Id);
        test.stopTest();
        
    }
    Static testmethod void createCons() {
        test.startTest();
        List<Contact> cons = [Select id,email,firstname,lastname,phone,ViewBoard_User_Type__c,AccountId,Marketing_Post_Sales__c from Contact limit 2];        
        EducationRegLight.createCons(cons);
        cons[0].Email = '@@@badformat';
        try{
            EducationRegLight.createCons(cons);
        }catch(Exception e){
            
        }
        test.stopTest();
        
    }
    Static testmethod void updateContacts() {
        test.startTest();
        List<Contact> cons = [Select id,email,firstname,lastname,phone,ViewBoard_User_Type__c,AccountId,Marketing_Post_Sales__c from Contact limit 2];        
        EducationRegLight.updateContacts(cons);
        test.stopTest();
        
    }
    Static testmethod void createCon() {
        test.startTest();
        Account acc = [Select id from account limit 1];
        String accId = acc.Id;
        Contact con = new Contact();
        con.FirstName = 'John';
        con.LastName = 'Smith';
        Con.Email = 'someemail@mailtestingthisweird.com';
        con.AccountId = accId;
        
        EducationRegLight.createCon(con);
        
        test.stopTest();
        
    }
    Static testmethod void createOrder() {
        test.startTest();
        Account a = [Select id from account limit 1];
        
        Order oError = new Order();
        oError.EffectiveDate = Date.Today();
        oError.AccountId = a.Id;
        oError.Status = 'Draft';
        
        Order o = new Order();
        o.EffectiveDate = Date.Today();
        o.AccountId = a.Id;
        o.Status = 'Draft';
        o.Named_Location_of_Training__c = 'fake location';
        o.Contact_Name__c = 'some contact';
        
        try{
            EducationRegLight.createOrder(o);
            EducationRegLight.upOrder(o);
            EducationRegLight.createOrder(oError);
            
        }catch(Exception e){
            system.debug('error ');
            system.debug(e);
        }
        
        o.EffectiveDate = Date.Today()-90;
        update o;
        /*
        try{
            EducationRegLight.createOrder(o,a);
            
        }catch(Exception e){
            
        }
        */
        
        o.Status = '';
        List <Order> ord = [Select id,effectivedate from order where accountid =: a.Id];
        
        test.stopTest();
        
        
        //system.assertEquals(ord.size(), 1);
        //system.assertEquals(ord[0].effectivedate,Date.today()-90);
         
    }
    Static testmethod void getTrainings() {
        test.startTest();
        
        Account a = [Select id from account limit 1];
        Order o = new Order();
        o.EffectiveDate = Date.Today();
        o.AccountId = a.Id;
        o.Status = 'Draft';
        o.Named_Location_of_Training__c = 'fake location';
        o.Contact_Name__c = 'some contact';
        insert o;
        
        try{
            EducationRegLight.getTrainings(a.Id);
            EducationRegLight.getPurchaseOrder(a.Id);
            EducationRegLight.editTraining(o.Id,a.Id);
        }catch(Exception e){
            system.debug('error ');
            system.debug(e);
        }
        
        test.stopTest();
    }
    Static testmethod void updateAcct() {
        test.startTest();
        
        Account a = [Select id from account limit 1];
        
        try{
            EducationRegLight.updateAcct(a);
        }catch(Exception e){
            system.debug('error ');
            system.debug(e);
        }
        
        test.stopTest();
    }
    
    
    
}