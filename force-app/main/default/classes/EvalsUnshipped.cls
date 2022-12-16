public class EvalsUnshipped {  
    @AuraEnabled
     public static List<Eval_Request__c> getEvals(String recid)
    {     
    	
        List<Eval_Request__c> e = new List<Eval_Request__c>();
        system.debug('recid is '+recid);
        //query user id so we can get contact id    	
        Id userId = UserInfo.getUserId();
        
        /*
        List<Contact> con = [SELECT ID FROM Contact WHERE UserID__c = :userId limit 1];         
        String conid = con[0].Id;
        */
        if(recid == null ){
            //get list of evals that have not shipped and belong to user and return to component
             e = [Select Id, name,Billing_Contact_Name__c,Billing_Contact_Name__r.Account.Name,Products_List__c ,
                          Eval_Process_Stage__c	,Opportunity_Name__r.Name, Products__c from Eval_Request__c
                          where Eval_Process_Stage__c != 'Shipped'
                          and Eval_Process_Stage__c != 'Closed' 
                          and Eval_Process_Stage__c != 'Cancelled'
                          and Eval_Process_Stage__c != 'Cancellation Requested'
                  	      and Eval_Process_Stage__c != ''
                          and ownerId =:userId];
        }else if(recid.substring(0,3) == '001'){
            
            e = [Select Id, name,Billing_Contact_Name__c,Billing_Contact_Name__r.Account.Name,
                 Eval_Process_Stage__c	,Opportunity_Name__r.Name, Products__c from Eval_Request__c
                where Billing_Contact_Name__r.AccountId = : recid or Shipping_Contact_Name__r.AccountId = : recid];
            
         }else if(recid.substring(0,3) == '003'){
             
              
             e = [Select Id, name,Billing_Contact_Name__c,Billing_Contact_Name__r.Account.Name,
                          Eval_Process_Stage__c	,Opportunity_Name__r.Name, Products__c from Eval_Request__c
                          where Billing_Contact_Name__c =:recid or Shipping_Contact_Name__c = : recid];
             
         }    
        
        return e;
         
    }

}