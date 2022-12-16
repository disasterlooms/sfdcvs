public without sharing class EvalContacts {
    @auraEnabled
    public static List<Sobject> getRelatedRecords(String recid){
        // this is the most recent method created to allow the lightning compent to get all
        // necessary records in one call to server. There are a few queries, 
        // but it is easier to split the related records instead of creating one 
        // query using relationships. 
        // This is because we need flexibility in checking which fields are required
        // 
        // eventually refactoring this code we only need this method and no others but there
        // needs update on the component itself as it checks a few different items to ensure 
        // the best data and user experience. 
        // 
        // 
        List<Sobject> relatedRecords = new List<Sobject>();
        
        Schema.SObjectType convertType = Schema.getGlobalDescribe().get('Eval_Request__c');
        Sobject genericObject = convertType.newSObject();
        
        DescribeSObjectResult describeResult = genericObject.getSObjectType().getDescribe();
        
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        
        
        String query =		  ' SELECT ' +		      String.join( fieldNames, ',' ) + '  FROM '
            +		      describeResult.getName()	+' where id =: recid limit 1' 	;		
        // return generic list of sobjects or typecast to expected type
        
        List<Eval_Request__c> records = Database.query( query );		
        
        System.debug( records[0] );
        
        relatedRecords.add(records[0]);
        
        
        Eval_Request__c eval = records[0];
        
        try{
            Contact cbill = [Select id, name,firstname,lastname,email,phone,mailingstreet,mailingcity,mailingstate,
                             mailingpostalcode,mailingcountry,title,Account.Type, Account.Industry,
                             Account.Owner.Name,Account.BillingStreet,Account.BillingCity,Account.BillingState,Account.BillingPostalCode,Account.Name,
                             Account.BillingCountry from Contact where id = : eval.Billing_Contact_Name__c limit 1];
            relatedRecords.add(cbill);
        }catch(Exception e){
            
        }
        
        try{
            Contact cship = [Select id, name,firstname,lastname,email,phone,mailingstreet,mailingcity,mailingstate,Account.Name,
                             mailingpostalcode,mailingcountry,title,Account.Type, Account.Industry,
                             Account.Owner.Name,Account.BillingStreet,Account.BillingCity,Account.BillingState,Account.BillingPostalCode,
                             Account.BillingCountry from Contact where id  = : eval.Shipping_Contact_Name__c limit 1];
            relatedRecords.add(cship);
            
        }catch(Exception e){
            
            
        }
        
        if(eval.Opportunity_Name__c != null){
            try{
                Opportunity o = [Select id, name,StageName,Amount,CloseDate,Createdby.LastName,Account.Name
                                 from Opportunity where id = : eval.Opportunity_Name__c limit 1];relatedRecords.add(o);
                
            }catch(Exception e){
                String t = 'Eval Approval Opportunity Query Error';AdminErrorMessage.SendError(e,t);
            }  
        }
        
        try{
            Contact creseller = [Select id, name,firstname,lastname,email,phone,mailingstreet,mailingcity,mailingstate,Account.Name,
                             mailingpostalcode,mailingcountry,title,Account.Type, Account.Industry,
                             Account.Owner.Name,Account.BillingStreet,Account.BillingCity,Account.BillingState,Account.BillingPostalCode,
                             Account.BillingCountry from Contact where id  = : eval.Reseller_Contact_Name__c limit 1];
            relatedRecords.add(creseller);
            
        }catch(Exception e){
            
            
        }

        try{
            User userData = [Select id, name,street,city,email,state,country,postalcode,phone
             from User where id  = : UserInfo.getUserId() limit 1];
            relatedRecords.add(userData);
            
        }catch(Exception e){
            
            
        }
        
        
        
        return  relatedRecords;
        
    }
    
    @auraEnabled
    public static Boolean checkShipping(Contact shipping){
        boolean shipcon = false;
        Contact con = shipping;
        system.debug('shipping info ');
        system.debug(con);
        system.debug(shipping);
        if(con.mailingstreet != null && con.mailingcity != null && con.phone != null && con.MailingStateCode != null && con.mailingpostalcode != null&& con.MailingCountryCode != null && con.email != null){            
            shipcon = true;
        }else if(con.mailingstreet != null && con.mailingcity != null && con.phone != null && con.mailingpostalcode != null && con.mailingcountry != null && con.email != null
                 && con.MailingCountryCode != 'Mexico' && con.MailingCountryCode != 'United States' && con.MailingCountryCode != 'Canada' && con.MailingCountryCode != 'Brazil'){
                     shipcon = true;
                 }else{
                     shipcon = false;
                 }
        
        return shipcon;
    }
    @auraEnabled
    public static Boolean checkBilling(Contact billing){
        boolean billcon = false;
        Contact con = billing;
        if(con.mailingstreet != null && con.mailingcity != null && con.phone != null && con.MailingStateCode != null && con.mailingpostalcode != null&& con.MailingCountryCode != null && con.email != null){            
            billcon = true;
        }else if(con.mailingstreet != null && con.mailingcity != null && con.phone != null && con.mailingpostalcode != null && con.mailingcountry != null && con.email != null
                 && con.MailingCountryCode != 'Mexico' && con.MailingCountryCode != 'United States' && con.MailingCountryCode != 'Canada' && con.MailingCountryCode != 'Brazil'){
                     billcon = true;
                 }else{
                     billcon = false;
                 }
        
        return billcon;
    }
    @auraEnabled
    public static void getEval(Eval_Request__c eval){
        //eval is updated 
        update eval;
    }
    
}