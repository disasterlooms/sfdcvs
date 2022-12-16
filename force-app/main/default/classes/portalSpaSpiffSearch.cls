public  without sharing class portalSpaSpiffSearch {
    @AuraEnabled
    public static List<Quote> getSpas(String spaName){
        String spa = spaName;
        spaName = '%'+spaName+'%';
       List<Contact> cons = new List<Contact>();
       List<String> accts = new List<String>();        
      
        if(!test.isRunningTest()){
            cons = [Select Id,AccountId,Account.ParentId, Portal_Corporate_Spiff_Admin__c  from Contact where id in (Select ContactId  from user where id =:  userinfo.getuserId() )];
            if(cons.size() > 0 && cons[0].Portal_Corporate_Spiff_Admin__c){
                accts.add(cons[0].AccountId);accts.add(cons[0].Account.ParentId);
            }
        }       
         /*
        
        List<Account> partnerAcct = new List<Account>();
        if(test.isRunningTest()){
            Opportunity_partner__c part = [Select partner_account__c from Opportunity_partner__c where opportunity__c in 
                                           (select opportunityid from quote where name =: spa)];
            
            Account a = [Select id from account where id =: part.partner_account__c];           
            partnerAcct.add(a);
        }
        
        try{
            partnerAcct =  [Select id, parentid from account where id = : con.AccountId
                            or id =: con.Account.ParentId];
        }catch(Exception e){
            if(!test.isRunningTest()){
                throw new AuraHandledException('Darn it! Something went wrong: '+ e.getMessage()+ ' account id = '+con.AccountId);
            }
        }
        */
        List<Quote> record = new List <Quote>();
        List<Quote> recordConRole = new List <Quote>();
        
        recordConRole = [select id, name , AccountId,Account.Name from Quote where
                  Opportunityid in (Select OpportunityId from OpportunityContactRole
                                    where ContactId  in : cons) and Status in ('Approved','Needs Review')
                  and Name like : spaName order by expirationdate desc limit 75];
        
        
        record = [select id, name , AccountId,Account.Name from Quote where
                  Opportunityid in (Select Opportunity__c from Opportunity_partner__c
                                    where Reseller_Contact__c  in : cons or partner_account__c in : accts) and Status in ('Approved','Needs Review')
                  and Name like : spaName order by expirationdate desc limit 75];
        
        record.addAll(recordConRole);
        
        return record;
    }
    
}