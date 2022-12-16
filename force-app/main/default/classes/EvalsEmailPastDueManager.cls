global class EvalsEmailPastDueManager implements Schedulable {
  global void execute(SchedulableContext sc) {
      //get list of all the directors that have sales direct reports
      //List <User> directors = [Select Id,Contact_ID__c from User where Profile.Name = 'Sales Directors' and isactive =true];
      //create a set of all the contactids of those managers
      //Set<String> managers = new Set<String>();
      	//for(User u : directors){
           //managers.add(u.Contact_ID__c);
      	//}
       List <EmailTemplate> templateId = [Select id from EmailTemplate where name = 'Weekly Sales Rep Eval Status Managers'];   
      //get a list of contacts that are managers and loop through that list to send each one an email. 
      List<Contact> cons = [Select Id, UserID__c , UserID__r.Profile.Name from Contact
                            where UserID__r.Profile.Name = 'Sales Directors'
                           and UserID__r.isActive = true];
      //see how many contacts exist
      system.debug('results num: '+cons.size());
        if(cons.size()>0){
    
          for(Contact m : cons){
    			
            system.debug('manager con id: '+m.Id);
    
            Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
                String[] cc = new String[] {Label.AdminEmail};
                mail.setTargetObjectId(m.Id);
                mail.setWhatId(m.Id);
                mail.setTemplateId(templateId[0].Id);
                mail.setCcAddresses(cc); 
                mail.setSaveAsActivity(false);           
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    
            }
    
    
        }
        
      }
}