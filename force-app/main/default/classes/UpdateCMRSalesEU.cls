global class UpdateCMRSalesEU implements 
    Database.Batchable<sObject>, Database.Stateful {
    
    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'Select id from account limit 1'
        );
    }

    global void execute(Database.BatchableContext bc, List<Account > comps){
        // process each batch of records
      /* List<CMRSales__CMRSales__c> eusales = [Select Id,  End_User_Account__c,    POS_Sales__c, 
                                        CMRSales__EndUserCompanyID__c,  CMRSales__EndUserCompanyID__r.CMRSales__Account__c 
                                        from CMRSales__CMRSales__c where CMRSales__EndUserCompanyID__c In: comps];
                    
                     List<CMRSales__CMRSales__c> lineitems = new List<CMRSales__CMRSales__c>();
                     List<CMRSales__CMRCompany__c > compToUpdate = new List<CMRSales__CMRCompany__c >();
                     
                     for(CMRSales__CMRSales__c Line : eusales ){
                        line.POS_Sales__c = Line.CMRSales__EndUserCompanyID__r.CMRSales__Account__c;
                        lineitems.add(Line);
              }
               TriggerContextUtility.setFirstRunFalse();
               update lineitems;
               
               for(CMRSales__CMRCompany__c  c : comps){
                   c.SalesObjectUpdate__c = false;
                   compToUpdate.add(c); 
               }                   
              update compToUpdate;   
      */

        
    }    

    global void finish(Database.BatchableContext bc){
        /*
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
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); */

    }    

}