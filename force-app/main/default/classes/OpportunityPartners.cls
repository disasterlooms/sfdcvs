public class OpportunityPartners {
    @AuraEnabled
    public static List<Opportunity_Partner__c> getOppLInes(String oppid){
        system.debug('partners op id '+ oppid);
        // without an ID, simply specify the object to then derive the sobject type		
        
        DescribeSObjectResult describeResult = Opportunity_Partner__c.getSObjectType().getDescribe();
        
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        
        String query =		  ' SELECT ' +		      String.join( fieldNames, ',' ) +		  ', Partner_Account__r.Name,Reseller_Contact__r.Name  FROM '
            +		      describeResult.getName()	+
            ' WHERE Opportunity__c = : oppid or quote__c =: oppid  or partner_account__c = : oppid order by Partner_Type__c desc'	;		
        // return generic list of sobjects or typecast to expected type
        List<SObject> records = Database.query( query );
        Id opportunityId = [select OpportunityId from Quote where id=:oppid].OpportunityId;
       
      //  List<OpportunityContactRole> ocrs = [select Role, ContactId, OpportunityId, Contact.Name, Contact.Email, Contact.AccountId from OpportunityContactRole where OpportunityId=:opportunityId and role='End User Contact'];
    //    List<OpportunityTeamMember> otms = [select name, User.Email from OpportunityTeamMember where OpportunityId=:opportunityId];
        Set<String> emails = new Set<String>();
        for(SObject record: records){
            emails.add((String)record.get('ResellerSpaEmail__c'));
        }
      /*  for(OpportunityTeamMember otm: otms){
            Opportunity_Partner__c op = new Opportunity_Partner__c(Partner_Type__c='Opportunity Team Member');
            op.Contact_Name__c = otm.Name;
            op.Partner_Account__c = [select id from Account where name='ViewSonic Corporation' limit 1].id;
            op.ResellerSpaEmail__c = otm.User.Email;
            op.Quote__c=oppid;
            op.Opportunity__c=opportunityId;
            if(!emails.contains(op.ResellerSpaEmail__c)){
                insert op;
                records.add(op);
            } 

        }*/
  /*      for(OpportunityContactRole oc: ocrs){
            Opportunity_Partner__c op = new Opportunity_Partner__c(Partner_Type__c='End User Contact'); 
            System.debug(oc);
            op.Reseller_Contact__c=oc.ContactId;
            op.Partner_Account__c=oc.Contact.AccountId;
            op.ResellerSpaEmail__c=oc.Contact.Email;
            op.Quote__c=oppid;
            op.Opportunity__c=opportunityId;
            if(!emails.contains(op.ResellerSpaEmail__c)){
                insert op;
                records.add(op);
            } 
        }*/
        System.debug( records );
        //[SELECT Id,Opportunity__c,Partner_Account__r.Name,Partner_Type__c,Reseller_Contact__c
               // FROM Opportunity_Partner__c
                //WHERE Opportunity__c = :oppid order by Partner_Type__c desc]; 
        
        return records;
    }
    @AuraEnabled
    public static List<Opportunity_Partner__c> deleteOppLines(List<Opportunity_Partner__c> dpartners, String oppid){
        system.debug('prods ' +dpartners);
        
        
        system.debug(dpartners);
        delete  dpartners;
        return [SELECT Id,Opportunity__c,Partner_Account__r.Name,Partner_Type__c,Reseller_Contact__c
                FROM Opportunity_Partner__c
                WHERE Opportunity__c = :oppid order by Partner_Type__c desc];        
        
    }
    @AuraEnabled
    public static List<Opportunity_Partner__c> updatePartners(List<Opportunity_Partner__c> uppartners, String oppid){
        
        update uppartners;
        system.debug(uppartners);
        return [SELECT Id,Opportunity__c,Partner_Account__r.Name,Partner_Type__c,Reseller_Contact__c
                FROM Opportunity_Partner__c
                WHERE Opportunity__c = :oppid order by Partner_Type__c desc];
        
        
    }
}