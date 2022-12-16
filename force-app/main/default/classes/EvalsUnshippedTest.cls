@isTest
private class EvalsUnshippedTest {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void EvalsUnshipped()
        
    {
        //passed on 10.27.2021
        test.startTest();   
        
            
            
            
            
            
            Account a = [Select Id, Name,Type,billingstate from Account where name ='ZZpbest' limit 1];
            Contact con = new Contact();
            try{
                 con = new Contact(FirstName='Ranfaseasesaddom',LastName='AafdsdfaspexTest', mailingcountrycode='US',
                                      email='apextestasfasdf@apexmail.com', phone='9995557asfd865',AccountId=a.id,MailingStateCode='CA',
                                      UserId__c = UserInfo.getUserId() );
            }catch(Exception e){
                con = [Select id from Contact where accountid =: a.Id limit 1];
			}
            
            
            
            Eval_Request__c ev = new Eval_Request__c(
                Expected_Receive_Date__c= date.today(),
                Evaluation_Owner__c = con.id,
                Eval_Process_Stage__c = 'Awaiting Submission Request'
                
            ); 
            insert ev; 
            //
            Contact c = [Select Id,AccountId from Contact where LastName ='tonythetester' limit 1]; 
            
            //test evals unshipped controller 
               
            List<Eval_Request__c> evals = EvalsUnshipped.getEvals(null); 
            //system.assertEquals(0, evals.size());
            
            List<Eval_Request__c> evalscon = EvalsUnshipped.getEvals(c.Id); 
            //system.assertEquals(1, evalscon.size());
            
            List<Eval_Request__c> evalsacc = EvalsUnshipped.getEvals(c.AccountId); 
            //system.assertEquals(1, evalscon.size());
            test.stopTest();
    }
}