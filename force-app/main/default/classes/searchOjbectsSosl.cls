public with sharing class searchOjbectsSosl {
    @AuraEnabled
    public static List<List<SObject>> getRecId(String recordId){
        
        List<List<SObject>> searchList = new List<List<SObject>>(); 
        
        List<Eval_Request__c> evals = [Select id,name from Eval_Request__c where Billing_Contact_Name__r.AccountId =: recordId or Shipping_Contact_Name__r.AccountId =:recordId];
        
        List<Opportunity> oppids = [Select id from Opportunity where AccountId =: recordId];
        
        List<Quote> spaids = [Select id from Quote where AccountId =: recordId];
        
        List<Contact> cons = [Select id from Contact where AccountId =: recordId];
        
        List<Task> tasks = [Select id,subject,activityDate,type, Description,whatid,whoid,ownerId,Owner.Name from 
                            Task where Type != 'Email' and Type != 'email' and (whatid =:recordId or whatid  in :oppids or whoid  in :cons or whatid  in :spaids ) order by activityDate desc limit 10];
        
        
        List<Event> events = [Select id,subject,activityDate, Description,whatid,whoid,OwnerId,Owner.Name from 
                              Event where whatid =:recordId or whatid  in :oppids or whatid  in :spaids or whoid  in :cons order by activityDate desc limit 10];        
        
        
        List<EmailMessage> mailmsg = [Select id,subject,MessageDate , TextBody ,HtmlBody,ParentId,FromName,fromAddress  from 
                                      EmailMessage where RelatedToId  =:recordId or RelatedToId in :oppids or RelatedToId in :spaids order by MessageDate  desc limit 10];
        
        
        searchList.add(tasks);
        searchList.add(events); 
        searchList.add(mailmsg);
        searchList.add(evals); 
        
        system.debug('rec id '+recordId);
        system.debug(searchList);
        
        return searchList;
        
    }
    
}