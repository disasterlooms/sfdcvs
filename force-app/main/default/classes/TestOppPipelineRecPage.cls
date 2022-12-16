@isTest
private class TestOppPipelineRecPage {
@testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void getPicklists()  
      {         
           test.startTest();
           OppPipelineRecPage.getStatus();
           OppPipelineRecPage.getUser();
           test.stopTest();
      }
    static testmethod void getPipe()  
  {
      List<Opportunity> oppid = [Select Id,Name,StageName from Opportunity limit 5];
      List<Opportunity> opps = new List<Opportunity>();
      List<Account> acc = [Select Id from Account limit 5];
      List<Contact> con = [Select Id from Contact limit 5];
      
      String ofields = 'Id,AccountId, Account.Name,Product_Name_Main__c,'+
                       'CloseDate,Project_or_Site_Information__c,name,Resellers_and_Type__c,'+
                       'Pricebook2Id';
      String pfields = 'Name,Quantity,Product2Id,Product2.Name,ServiceDate'+
                       ',Ship_Out_Date__c,status__c';
      
      String clause = '';
      
      String recid = oppid[0].Id;
      
      system.debug(recid+' opp id');
      List<OpportunityLineItem> lines = [Select Id,Quantity,Name,Status__c from OpportunityLineItem limit 5];
      
      test.startTest();    
      opps = OppPipelineRecPage.getPipe(recid,ofields,pfields,clause);
      
      recid = acc[0].Id;
      OppPipelineRecPage.getPipe(recid,ofields,pfields,clause);
      
      recid = con[0].Id;
      OppPipelineRecPage.getPipe(recid,ofields,pfields,clause);
      
      //this will cause database update success
      OppPipelineRecPage.updateopps(opps,lines);
      
      //this will cause database update failure by putting bad value in picklist
      //also use other oppid list to ensure records are being saves
       
      for(OpportunityLineItem l : lines){
          
          l.Status__c = 'failure';
      }
      opps = oppid;
      OppPipelineRecPage.updateopps(opps,lines);
      test.stopTest();
  }
    static testmethod void delProd()  
      {         
           List<Opportunity> opps = [Select Id from Opportunity limit 5]; 
           List<OpportunityLineItem> lines = [Select Id,Quantity,Name from OpportunityLineItem limit 5];
           String prodid = lines[0].Id;
           String product = '';
          
           test.startTest();
           OppPipelineRecPage.delProd(prodid,opps,lines,product);
           test.stopTest();
      }
	
}