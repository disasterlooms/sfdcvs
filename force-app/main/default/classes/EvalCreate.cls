public without sharing class EvalCreate {
    
    public static void updateeval(List<Eval_Request__c> evaluations){
        //create sets and add creator of record and
        //evaluation billing contact information to be mapped
        //later to set of records
        
        system.debug('updating eval bililng ');
        Set<Id> creator = new Set<Id>();
        Set<String> evalbill = new Set<String>(); 
        for(Eval_Request__c e : evaluations){
            evalbill.add(e.Billing_Contact_Name__c);
            creator.add(UserInfo.getUserId());
        }
        
        Map<String, Contact> bills = new Map<String, Contact>();
        for (Contact b : [    
            SELECT Name,Id,AccountId,MailingStreet,MailingState,MailingPostalCode,MailingCountry,
            MailingCity,Account.BillingStreet,Account.BillingCity,Account.BillingState,Account.BillingPostalCode,
            Account.BillingCountry FROM Contact
            WHERE Id in: evalbill
        ]) bills.put(b.Id , b);
        
        Map<String, User> managers = new Map<String, User>();
        for (User m : [    
            SELECT Id, Manager.Contact_ID__c,Contact_ID__c,managerId FROM User WHERE Id in: creator
        ]) managers.put(m.Id , m);
        for(Eval_Request__c e : evaluations){
            if(bills.containsKey(e.Billing_Contact_Name__c )== true){                
                Contact bc  = bills.get(e.Billing_Contact_Name__c);
                User u  = managers.get(UserInfo.getUserId());
                
                //e.Manager_Contact__c = u.Manager.Contact_ID__c;
                e.Billing_Account__c = bc.AccountId;
                //e.ManagerID__c = u.ManagerId;
                //e.OwnerIDUser__c = e.CreatedById;            
                //e.Evaluation_Owner__c = u.Contact_ID__c;
                //e.Products_Requested__c = e.Product_Name__r.name+' '+e.Product_Name_2__r.name+' '+
                //e.Product_Name_3__r.name+' '+e.Product_Name_4__r.name+' '+
                //e.Product_Name_5__r.name+' ';
                
            } 
        }
    }
}