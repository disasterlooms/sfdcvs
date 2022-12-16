public class SpaAutoRenewalController {
    @AuraEnabled 
    public static quote  getUpdatedQuote(string reason,string currentRecord){
        quote  q = [select id, Reason_For_Renewal__c,Auto_Renew_End_Date__c,Auto_Renew_Start_Date__c,Auto_Renew__c,
                    BR_ManagerId__c from quote where id =:currentRecord];
        User u = [Select id, managerid from user where id =: userinfo.getUserId()];
        
        q.Reason_For_Renewal__c = reason;
        q.BR_ManagerId__c = u.managerId;
        //q.Auto_Renew_Start_Date__c = date.today();
        //q.Auto_Renew_End_Date__c = date.today().addYears(2); 
        //q.Auto_Renew__c = true;
        //commenting out line 8 because the approval final action will control this field
        //commenting line 6 and 7 by changing this update to field update on approval step of the approval process.
        
        update q;
        system.debug('@@@Q-------'+q); 
        
         /////Invoking the Approval process
        //
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitted for SPA Auto Renewal Approval');
        req1.setObjectId(q.id);   // req1.setObjectId(q.OpportunityId__c);
        
        // Submit on behalf of a specific submitter
        //req1.setSubmitterId(unsub.Id); 

        // Submit the record to specific process and skip the criteria evaluation
        req1.setProcessDefinitionNameOrId('SPA_Auto_Renewal_Reques2');
        //req1.setSkipEntryCriteria(true);
        SYSTEM.debug('@@@@@Approval'+req1);
        // Submit the approval request for the account
        try{
        Approval.ProcessResult result = Approval.process(req1);
        }catch(Exception e){
            //throw new AuraHandledException(e.getMessage());
        }
        
        
        return q;
    }
    
}