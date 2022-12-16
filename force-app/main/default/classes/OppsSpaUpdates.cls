public class OppsSpaUpdates{
    // These variables store Trigger.oldMap and Trigger.newMap
    Map<Id, Opportunity> oldOpps;
    Map<Id, Opportunity> newOpps;
    
    
    public OppsSpaUpdates(
        Map<Id, Opportunity> oldTriggerOpps, 
        Map<Id, Opportunity> newTriggerOpps) {
            
            oldOpps = oldTriggerOpps;
            newOpps = newTriggerOpps;
        }
    
    // The one method your master trigger will call
    public void SpaSubmission() {
        
        List<Quote> quotesToInsert = new List<Quote>();
       
        system.debug('check the size of the new map ' +newOpps.size());
        if(newOpps.size() >0){
            
            User u = [Select FirstName,LastName,Name,Id,Email, Phone,Sales_Category__c from user where id = : UserInfo.getUserId() ];
            
            for (Opportunity opp : newOpps.values()) {
                Opportunity oldOpp  = oldOpps.get(opp.Id);
                 if((opp.StageName == 'Distributor SPA Request'   && opp.HasOpportunityLineItem == true && opp.Count_of_Quotes__c < 1) ||
                    (opp.ApexTest__c == true && opp.Cloning__c == false)){
                     Quote q = new Quote(OpportunityId = opp.Id,
                                    Name= opp.SPA_ID__c,
                                   Status= 'Needs Review');
                quotesToInsert.add(q);
                system.debug('spaid '+opp.SPA_ID__c+ ' oppid '+opp.Id);                 
                     
                 }
                
                //check if the accountid field is blank but the end user account lookup is filled and update accountid
                if(opp.AccountId == null && opp.End_User_Lookup_Account__c != null){
                    opp.AccountId = opp.End_User_Lookup_Account__c;                    
                }
            }
           
        }
        /* -- jason orbison 10.30.19 -- no longer adding quote using a trigger. instead using the flow on the opporutnity page to control submissions 
         * and resubmissions for Partners */
        
         //insert quotesToInsert;
    }  
    /*
    public void SpaStageApproval() {
        
        User u = [SELECT Id,Name,Email,Distributor_Rep__c, PartnerDistiName__c,PartnerDistiEmail__c,
                  PartnerDistiPhone__c,AccountId,Sales_Category__c
                  FROM User WHERE Id= :UserInfo.getUserId()] ;
        
        List<Quote> quotesToUpdate = new List<Quote>();
        
        Map<Id, Quote> mquotes = new Map<Id, Quote>();
        for(Quote q : [Select Id,Resubmitter__c,Resubmitter_Email__c,Resubmission_Date__c,Resubmission_Notes__c,
                       Status,OpportunityId from Quote  where  First_Time_Buyer__c = false and Opportunityid in: newOpps.values() order by CreatedDate desc ])
            mquotes.put(q.OpportunityId , q);
        
        for (Opportunity o : newOpps.values()) {
            Opportunity old  = oldOpps.get(o.Id);
            
            if (o.Spa_Recent_Approval_Date__c != old.Spa_Recent_Approval_Date__c) {       
                o.EDI_Approval_Date_Time__c = DateTime.Now();
            } 
            
            if ((o.Spa_Resubmission_Note__c != null && old.Spa_Resubmission_Note__c == null) || o.Spa_Resubmission_Note__c != old.Spa_Resubmission_Note__c){
                if(o.Spa_Resubmission_Note__c != null && old.Spa_Resubmission_Note__c == null)
                o.Spa_Stage__c = 'Resubmitted';
                o.Spa_Resubmitter__c = u.Id;
                o.Spa_Resubmitter_Email__c = u.Email;
                o.Spa_Resubmitted_Date__c = DateTime.Now();
                
                OpportunityTeamMember team = new OpportunityTeamMember(
                    OpportunityId = o.Id,
                    TeamMemberRole = u.Sales_Category__c,
                    UserId = u.Id,
                    OpportunityAccessLevel = 'Edit'    
                );
                insert team;
                
                if(mquotes.containsKey(o.Id) && o.Spa_Resubmission_Note__c != null && old.Spa_Resubmission_Note__c == null){
                    Quote q = mquotes.get(o.Id);
                    
                    q.Resubmitter__c = u.Id;
                    q.Resubmitter_Email__c = u.Email;
                    q.Resubmission_Date__c = DateTime.Now();
                    q.Resubmission_Notes__c = o.Spa_Resubmission_Note__c;
                    q.Status = 'Needs Review';
                    
                    quotesToUpdate.add(q);
                    
                }else if(mquotes.containsKey(o.Id) && o.Spa_Resubmission_Note__c != old.Spa_Resubmission_Note__c ){
                    Quote q = mquotes.get(o.Id);    
                    q.Resubmission_Notes__c = q.Resubmission_Notes__c +' '+o.Spa_Resubmission_Note__c;
                    quotesToUpdate.add(q);
                }
            } 
            
            
            if(o.Spa_Stage__c == 'Rejected' && old.Spa_Stage__c != 'Rejected'){
                o.Spa_Reject_Date__c = Date.Today();
                
            }
        }
        update quotesToUpdate;

		
    }
    */
    /*
    public static  void AddTeam(List<Opportunity> opps,Map<Id, Opportunity> oldOpps,Map<Id, Opportunity> newOpps) { 
        
        List<Opportunity> oppsTeam = new List<Opportunity>();
        
        for(Opportunity o : opps){
            Opportunity oldOppo  = oldOpps.get(o.Id);
            if(oldOppo.SPA_Request__c == null &&  o.SPA_Request__c != null && o.StageName !='Distributor SPA Request'){
                //comment - adding opps to list that have a change in spa request
                //and sending to opp team update helper class
                oppsTeam.add(o) ;
            }
            
            OpportunityTeamAdd.teams(oppsTeam);
            
        }
    }
	*/
    
}