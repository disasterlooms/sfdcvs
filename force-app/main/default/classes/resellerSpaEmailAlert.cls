global class resellerSpaEmailAlert {
   @InvocableMethod
   global static void sendNotification(List<String> idList){
       System.debug(idList);
       List<string> emails = new list<String>();
       List<Id> oppPartners = new List<String>();
       Set<Id> oppTeamMemberIds = new Set<Id>();
       Set<Id> endUsers = new Set<Id>();
       List<String> idList2 = idList[0].split(';');
       System.debug(idList2);
       for(String idVal : idList2){
          Id stringToId = idVal!=null&&idVal!='' ? (Id)idVal : null;
           if(stringToId!=null&& stringToId.getsobjecttype().getDescribe().getName()=='OpportunityTeamMember'){
               oppTeamMemberIds.add(stringToId);
           }
           else if(stringToId!=null&&stringToId.getsobjecttype().getDescribe().getName()=='OpportunityContactRole'){
               endUsers.add(stringToId);
           }
           else if(stringToId!=null&&stringToId.getsobjecttype().getDescribe().getName()=='Opportunity_Partner__c'){
               oppPartners.add(stringToId);
           }
                      
       }
       for(OpportunityTeamMember otm : [select id, User.Email from opportunityteammember where id in :oppTeamMemberIds]){
           emails.add(otm.User.Email);
       }
       for(OpportunityContactRole ocr : [select id, Contact_Email__c from OpportunityContactRole where id in :endUsers]){
           emails.add(ocr.Contact_Email__c);
       }
       System.debug('total emails: '+emails);
       System.debug('opp partners'+oppPartners);
   
    for(Id  op : oppPartners){
        
    
   Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
   message.setTargetObjectId(UserInfo.getUserId());
   message.setSenderDisplayName('Salesforce Admin');
   message.setReplyTo('no-reply@salesforce.com');
   message.setTreatTargetObjectAsRecipient(false);
 
   message.setUseSignature(false);
   message.setBccSender(false);
   message.setSaveAsActivity(false);
   EmailTemplate emailTemplate =[Select Id,Subject,Description,DeveloperName,Body from EmailTemplate where developername='SpaResellerApprovalResellerApproval' limit 1];
   //Get templete id for set the templete.

   message.setTemplateID(emailTemplate.id);//00X1H0000023GBb
   message.setWhatId(op); //This is important for the merge
                                    //fields in template to work
   message.toAddresses = emails;

   Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
	Messaging.SendEmailResult[] results = new List<Messaging.SendEmailResult>();
   if(!emails.isEmpty()) results = Messaging.sendEmail(messages);
 

    }
}
}