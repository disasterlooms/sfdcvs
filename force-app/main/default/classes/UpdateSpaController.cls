public class UpdateSpaController {
    @AuraEnabled 
    public static quote  getQuoteDetails(string currentRecord){
         quote  q = [select id, Business_Reason_for_Bid_Registration__c,Scope_of_Bid_Registration__c, List_of_Work_Activity_c__c,
                      BR_ManagerId__c from quote where id =:currentRecord];
      system.debug('@@@Q-------'+q);
        return q;
    }
     @AuraEnabled 
    public static String  getUpdatedRecord(string currentRecord,string WorkActivity,string ScopeOfBidRegistration,string BusinessReasonforBidRegistration){
      // ResponseItemWrapper resp = new ResponseItemWrapper();
        quote  q = [select id, Spa_Request_Type__c,Business_Reason_for_Bid_Registration__c,OpportunityId__c,Scope_of_Bid_Registration__c, List_of_Work_Activity_c__c,
                    BR_ManagerId__c from quote where id =:currentRecord];
        User unsub = [SELECT Id,managerid FROM User WHERE id = :userInfo.getUserId() limit 1];
        string oppid = q.OpportunityId__c;
        q.Spa_Request_Type__c ='Bid Register Request';
        q.List_of_Work_Activity_c__c = WorkActivity;
        q.Business_Reason_for_Bid_Registration__c = BusinessReasonforBidRegistration;
        q.Scope_of_Bid_Registration__c = ScopeOfBidRegistration;
        q.BR_ManagerId__c = unsub.managerid;
        try{
            update q;
            //resp.SUCCESS = true;
            //resp.oppId = q.OpportunityId__c;
            
        }catch(Exception e){
            //resp.SUCCESS = false;
           // resp.MESSAGE = e.getMessage();
           system.debug(e.getMessage());
           throw new AuraHandledException('There was an error: '+e.getMessage());
        
        }
        
        //Id userId = userInfo.getUserId();
        
        

        system.debug('@@@@@q'+q);
       
        /////Invoking the Approval process
        //
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(q.id);   // req1.setObjectId(q.OpportunityId__c);
        
        // Submit on behalf of a specific submitter
        req1.setSubmitterId(unsub.Id); 
        
        // Submit the record to specific process and skip the criteria evaluation
        req1.setProcessDefinitionNameOrId('Bid_Register_Spa_Request');
        req1.setSkipEntryCriteria(true);
        SYSTEM.debug('@@@@@Approval'+req1);
        // Submit the approval request for the account
        Approval.ProcessResult result = Approval.process(req1);
        
		return oppid;
        
    }
    
   /* public class ResponseItemWrapper{
        @AuraEnabled public Boolean SUCCESS {get;set;}
        @AuraEnabled public Id oppId {get;set;}
        @AuraEnabled public String MESSAGE {get;set;}
    }*/

}