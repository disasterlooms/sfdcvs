public with sharing class LeadTriggerClass
{
    Map<Id, Lead> oldLeads;
    Map<Id, Lead> newLeads;
    
    public LeadTriggerClass(
        Map<Id, Lead> oldTriggerLeads,
        Map<Id, Lead> newTriggerLeads) {
            oldLeads = oldTriggerLeads;
            newLeads = newTriggerLeads;           
            
        }
    /*
     //Commenting out this class but we can use it later to save 1  query and not run the
     //region helper class unless there is a change to country.
     
    public  void countryChange(){
        
        List<Lead> leads = new List<Lead>();
        
        for(Lead l :   newLeads.values()){
            Lead old = oldLeads.get(l.Id);
            if(l.Country != old.Country){
                getRegionInfo.getRegionLead(trigger.new);
            }
        }
        
    }
   */
    public static void accountCompare(List<Lead> records)
    {
        system.debug('running lead email');
        Set<String> doms = new Set<String>();
        for(Lead l : records){
            if(!String.isBlank(l.email)){                
                String dom = l.email.mid(l.email.indexOfAny('@')+1,l.email.length());
                if(!dom.contains('hotmail')){
                    doms.add(dom);
                }
            }
        }
        system.debug('email');
        system.debug(doms);
        
        Map<String, GenericEmails__c > gens = new Map<String, GenericEmails__c >();
        for (GenericEmails__c c : [
            SELECT Name,Id FROM GenericEmails__c
            
        ]){                              
            gens.put(c.name, c);                
        }
        
        Map<String, Contact> con = new Map<String, Contact>();
        
        Map<String, Account> acctMap = new Map<String, Account>();
        
        
        List<Account> acctsToSearch = new List <Account> ();
        
        for (List<Account> accts : [SELECT id, name,Type,owner.name,owner.alias,industry ,ownerid,Domain__c,billingstate,billingcity,billingcountry FROM Account
                                    where Domain__c in : doms and HQ_Account_Check_if_HQ__c  = true]) {
                                        acctsToSearch.addAll(accts);                                            
                                    } 
        
        for (Account c : acctsToSearch){
            String dom = c.Domain__c;                
            if(!gens.containsKey(dom)){
                acctMap.put(dom, c);  
            }
        }  
        
        
        
        system.debug(con);
        
        for(Lead l : records){
            if(!String.isBlank(l.email)){  
                String dom = l.email.mid(l.email.indexOfAny('@')+1,l.email.length());
                system.debug('stringxxxx'+dom+'xxxx');
                if(acctMap.containsKey(dom)){
                    system.debug('found');
                    Account c = acctMap.get(dom);
                    l.account__c = c.Id;
                    l.Company = c.Name;
                    if(c.BillingState != null){
                        // l.State = c.BillingState;
                    }
                    if(c.BillingCity != null){
                        l.City = c.BillingCity;
                    }
                    if(c.BillingCountry != null){
                        //   l.Country = c.BillingCountry;
                    }
                    l.Account_Type__c = c.Type;
                    if(c.Owner.Alias != 'admin' && c.Owner.Alias != 'BidDesk' && c.Owner.Alias != 'cserv'){	
                        l.OwnerId = c.ownerId;
                    }
                    
                    
                }
                
            }
        }
        
    }
    /*
    public static void AddFinchClub(List<Lead> records)
    {
        //get the finch club campaign name
        //and then loop through the contacts from the insert or update trigger
        //this will add contacts to campaigns if they are finch enrolled
        List<Campaign> camp = [Select Id from Campaign where name ='Finch Club Members' limit 1];
        //make sure there is a campaign named finch club
        if(camp.size()>0){
            Set<String> members = new Set<String>();
            for (CampaignMember con : [
                SELECT Id, LeadId FROM CampaignMember
                WHERE Campaign.Name = 'Finch Club Members'])
                members.add(con.LeadId);
            List <CampaignMember> cm = new List <CampaignMember>();
            List <Lead> leads = [Select Id, FirstName, LastName, Email, OwnerId, Owner.Email,
                                 FinchClubStatus__c from Lead where Id In: records and ID not In : members];
            if(leads.size() >0){
                for (Lead l : leads){
                    // If check if this is a finch club member if so
                    //add to the campaign finch club
                    system.debug('finch status '+l.FinchClubStatus__c+' LastName '+l.LastName);
                    if(l.FinchClubStatus__c == 'Active - Enrolled'){
                        CampaignMember campm = new CampaignMember(CampaignId= camp[0].Id,
                                                                  LeadId=l.Id,
                                                                  Status='Sent'
                                                                 );
                        cm.add(campm); 
                    }try{
                        insert cm;
                    }catch(Exception e){
                        String t = 'Lead Finch Club ';
                        AdminErrorMessage.SendError(e,t);
                    }
                }
            }
        }
    }
*/
    
    public static void govSpendOptOutOfEmail(List<Lead> records){
        for(Lead l : records){
            if(l.GovSpend_ID__c!=null) l.HasOptedOutOfEmail=true;            
        }
    }
    
    public static void CsCallLead(List<Lead> records)
    {
        Campaign camp = new Campaign();
        
        try{
            camp = [Select Id from Campaign where name ='Customer Service Incoming Call' limit 1];
        }catch(Exception e){
            
        }
        
        
        List <Lead> leads = [Select Id,Customer_Service_Rep__c,name, FirstName,LastName, Email, OwnerId, Owner.Email,Log_Customer_Request__c,
                             Company,Owner.FirstName,Phone from Lead where Id In: records];
        
        List<Lead> leadsToUpdate = new List<Lead>();
        for (Lead l : leads){
            
            // run if the log customer request if filled out...then unfill in case there is a new call
            //the adding of task is commented out on insert line because it should be done on the email message
            
            if(l.Log_Customer_Request__c != null){
                Task t = new Task(WhoId= l.Id, ActivityDate= Date.Today(),
                                  Status='Completed',Subject= 'Customer called in, advised sales rep',
                                  Type = 'Call',Description= l.Log_Customer_Request__c,Campaign__c=camp.Id,
                                  Customer_Service_Rep__c = l.Customer_Service_Rep__c);
                
                insert t;
                
                String body = '';
                body += l.Owner.FirstName+ ',<br/><br/>' ;
                body += 'Please contact your reseller as they have contacted us and requested assistance. Here are the details:<br/><br/>';
                body += 'Account: '+l.Company +'<br/><br/>';
                body += 'Account: '+l.Name +'<br/><br/>';
                body += 'Phone: '+l.Phone +'<br/><br/>';
                body += 'Email: '+l.Email +'<br/><br/>';
                body += 'Request: '+l.Log_Customer_Request__c +'<br/><br/>';
                
                //message has if statement for testing because
                //assigment rules add a group without eamil address
                //
                Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
                String[] to = new String[] {l.Owner.Email};            
                    String[] cc = new String[] {Label.AdminEmail};
                        
                        if(l.Owner.Email == null){
                            mail.setToAddresses(cc); 
                        }else{
                            mail.setToAddresses(to);    
                        }
                system.debug('to email address '+to);
                system.debug('admin email address '+cc);
                
                mail.setHtmlBody(body);
                mail.setCcAddresses(cc);   
                mail.setSaveAsActivity(true);
                mail.setSubject('Customer Requests Contact.Regarding a Purchase');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                
                l.Log_Customer_Request__c = null;
                
                leadsToUpdate.add(l);
                
                CampaignMember cm = new CampaignMember(CampaignId= camp.Id,
                                                       LeadId=l.Id,
                                                       Status='Sent'
                                                      );
                insert cm;       
                
                
                
            }
            
        }
        update leadsToUpdate;
    }
}