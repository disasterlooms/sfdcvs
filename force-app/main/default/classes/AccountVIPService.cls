public without sharing class AccountVIPService {
    @AuraEnabled
    public static Account getStatus(String recid){
       Account a = [Select Id,VIP_Service_Reason_for_Request__c,VIP_in_Approval_Process__c  from Account where id = : recid limit 1];
        
       system.debug('vip '+a.VIP_in_Approval_Process__c);
        
       return a;
    }
    
    @AuraEnabled
    public static Account hotline(String recid){
        
        
        system.debug('this is the approval trigger');
        Account a = [Select Id,VIP_Service_Reason_for_Request__c, VIP_Products__c,
                     ApprovalManagerId__c, VIP_Hotline_Submitter__c     from Account where id = : recid limit 1];
        User curuser = [Select id, managerid from user where id =: Userinfo.getUserId()];
        
        a.VIP_Hotline_Submitter__c = curuser.id;
        a.ApprovalManagerId__c = curuser.managerid;
        update a;
        
        system.debug(a);
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for Hotline Service Only . '+ a.VIP_Service_Reason_for_Request__c);
        req1.setObjectId(a.id);  
        
        // Submit on behalf of a specific submitter
        req1.setSubmitterId(curuser.Id); 
        
        // Submit the record to specific process and skip the criteria evaluation
        req1.setProcessDefinitionNameOrId('Account_Hotline_Service');
        req1.setSkipEntryCriteria(true);
        SYSTEM.debug('@@@@@Approval'+req1);
        // Submit the approval request for the account
        Approval.ProcessResult result = Approval.process(req1);
        Approval.unlock(a.id);
        
                
        return a;
    }
    
    @AuraEnabled
    public static Account vip(String recid){
        Account a = [Select Id,VIP_Service_Reason_for_Request__c, VIP_Products__c,
                     ApprovalManagerId__c, VIP_Hotline_Submitter__c     from Account where id = : recid limit 1];
        User u = [Select id, managerid from user where id =: Userinfo.getUserId()];
        
        a.VIP_Hotline_Submitter__c = u.id;
        a.ApprovalManagerId__c = u.managerid;
        update a;
        
        system.debug(a);
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for VIP Approval . '+ a.VIP_Service_Reason_for_Request__c);
        req1.setObjectId(a.id);  
        
        // Submit on behalf of a specific submitter
        req1.setSubmitterId(u.Id);
        
        // Submit the record to specific process and skip the criteria evaluation
        req1.setProcessDefinitionNameOrId('Account_VIP_Service');
        req1.setSkipEntryCriteria(true);
        SYSTEM.debug('@@@@@Approval'+req1);
        // Submit the approval request for the account
        Approval.ProcessResult result = Approval.process(req1);
        Approval.unlock(a.id);
        
        List<Asset> prods = [Select id, product2.name from asset where accountid =: recid
                            and product2.name != null and TP__c = null and SerialNumber = null];
        String products = '';
        for(Asset p : prods){
            products = products+ p.product2.name+', ';
        }
        
        a.VIP_Products__c = products;
        update a;
        
        return a;
    }
}