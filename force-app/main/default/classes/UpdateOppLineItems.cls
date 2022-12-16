global class UpdateOppLineItems implements 
    Database.Batchable<sObject>, Database.Stateful {
    
    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT ID FROM OpportunityLineItem Where MarginUpdate__c = true AND '+
            'Product2.IsActive = True AND  Opportunity.Spa_Stage__c != null'
        );
    }

    global void execute(Database.BatchableContext bc, List<OpportunityLineItem> olines){
        // create a list to update each list 
       List<OpportunityLineItem> lineitems = new List<OpportunityLineItem>();
        //loop through a list of lists and set size at 200 each to prevent
        //dml size limit errors
        //
        for(List<OpportunityLineItem> lines : [Select Id,OpportunityId, Opportunity.AccountId,Margin__c,MarginText__c,
                    Landing_Cost2__c,Product2Id, Product2.Cost__c from OpportunityLineItem where Id In: olines
                                              Order By OpportunityId ]){
                     
                     for(OpportunityLineItem Line : lines){
                        line.MarginText__c = String.valueOf(line.Margin__c)+'%';
                        Line.Landing_Cost2__c = Line.Product2.Cost__c;
                        lineitems.add(Line);
              }
               //create a string for error messages
               //update the line items and the clear the line item list
               //send any errors to admin
                                           String  errormessages = '';
                                           TriggerContextUtility.setFirstRunFalse();
                                           List<Database.SaveResult> updateResults = database.update(lineitems, false);
                                           lineitems.clear();
                                                  for(Integer i=0;i<updateResults.size();i++){
                                                      if (!updateResults.get(i).isSuccess()){
                                                          Database.Error error = updateResults.get(i).getErrors().get(0);
                                                            String failedDML = error.getMessage();
                                                            lineitems.get(i);//failed record from the list
                                                            system.debug('Failed ID '+lineitems.get(i).Id); 
                                                            system.debug('Message '+ failedDML);
                                                            errormessages += 'Name: '+lineitems.get(i).Id+'<br/>'+'Error: '+ failedDML+ '<br/><br/>';
                                                          
                                                      }
                                                      
                                                  }
                                          Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
                                          String[] toAddresses = new String[] {Label.AdminEmail};
                                          mail.setToAddresses(toAddresses);
                                          mail.setReplyTo(Label.AdminEmail);
                                          mail.setSenderDisplayName('Apex oppline '+ ' error message');
                                          mail.setSubject('Error from Org : ' + UserInfo.getOrganizationName());
                                          mail.setPlainTextBody(errormessages);
                                          Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
                                                 
               
               
               List<Product2> prodToUpdate = new List<Product2>();
               List<Product2> prods = [Select Id from Product2 where LandedCostChange__c = true];
            
               for(Product2 p : prods){
                   p.LandedCostChange__c  = false;
                   prodToUpdate .add(p); 
               }                   
              update prodToUpdate ;    

        
    }    

    global void finish(Database.BatchableContext bc){
        System.debug(recordsProcessed + ' records processed. Shazam!');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
        // call some utility to send email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'jason.orbison@viewsonic.com'};
        mail.setToAddresses(toAddresses);
        mail.setReplyTo('jason.orbison@viewsonic.com');
        mail.setSenderDisplayName('Apex Batch Results');
        mail.setSubject('Batch Oppline Items Result: ');
        mail.setPlainTextBody('Errors: ' + job.NumberOfErrors + ' Total Job Items '+ job.TotalJobItems);
        //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

    }    

}