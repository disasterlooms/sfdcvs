public with sharing class UserOppTeam {
    @AuraEnabled
    public static void communityuser(String email) {
        
        
        User userinfo = [Select id, AccountId from user where email =:  email]; 
        List<Opportunity> ops = [Select id from opportunity where id in
 									(Select opportunity__c from opportunity_partner__c 
                                    where partner_account__c = '001A000000IiYzx')];
 


		List<Opportunity> opteam = [Select id from opportunity  
         									where id not in 
                                        (select opportunityid from opportunityteammember where userid = '0051H00000AL6AB') and
										id in : ops];
        
 		List<opportunity_partner__c> parts = [Select id, opportunity__c,Quote__c from opportunity_partner__c
                                              where partner_account__c = : userinfo.Accountid and opportunity__c in : opteam
                                              and opportunity__c in
                                              (Select opportunityid from quote where status = 'Approved' or status= 'In Review') order by createddate desc limit 8000];
        
        List<opportunity_partner__c> parttest = [Select id, opportunity__c,Quote__c from opportunity_partner__c
                                              where partner_account__c = : userinfo.Accountid and opportunity__c not in : opteam
                                              and opportunity__c in
                                              (Select opportunityid from quote where status = 'Approved' or status= 'In Review') order by createddate desc limit 8000];
        
        List<OpportunityTeamMember> team = new List<OpportunityTeamMember>();
        if(parts.size()==0){
            parts = parttest;
        }
        
        
        for(opportunity_partner__c p : parts){
            OpportunityTeamMember t = new OpportunityTeamMember(opportunityId = p.opportunity__c,
                                                                userid = userinfo.Id,
                                                                OpportunityAccessLevel = 'Edit',
                                                                TeamMemberRole = 'External Distributor',
                                                                Quote__c = p.Quote__c
                                                               );
            
            team.add(t);
            
        }     
        try{
            insert team;
        }catch(Exception e){String t = 'Disti Partners Add Team Error';system.debug(e);system.debug(t); AdminErrorMessage.SendError(e, t);try{database.insert(team, false);}catch(Exception er){system.debug(er);}
            
        }
    }
    @AuraEnabled
    public static void accTrans(String email) {
        
        
        //get the user that needs transfer but only after the state matrix has been updated
        //then get all the states the rep is over and then find related accounts. May have to do mulitple times
        //
        
        User userinfo = [Select id, AccountId from user where email =:  email];
        
        
        /*
List<opportunity_partner__c> parts = [Select id, opportunity__c,Quote__c from opportunity_partner__c
where partner_account__c = : userinfo.Accountid and opportunity__c in
(Select opportunityid from quote where status = 'Approved' or status= 'In Review') order by createddate desc limit 8000]; 
*/
        
    }
    @AuraEnabled
    public static void oppTrans(String emailfrom, String emailto) {
        
		system.debug('from '+emailfrom+' to '+emailto);        
        //get the user that needs transfer but only after the state matrix has been updated
        //then get all the states the rep is over and then find related accounts. May have to do mulitple times
        //
        
        User userinfo = [Select id, AccountId from user where email =:  emailto];
        List<Opportunity> opps = [Select id, ownerid, owner.email from opportunity where owner.email = : emailfrom order by lastmodifieddate desc limit 2000];
        for(Opportunity o :opps){
            o.OwnerId = userinfo.Id;
        }
        
        system.debug(opps);
        system.debug('opps');
        try{
            database.update(opps, false);
        }catch(Exception e){
            
        }
        
        
        /*
List<opportunity_partner__c> parts = [Select id, opportunity__c,Quote__c from opportunity_partner__c
where partner_account__c = : userinfo.Accountid and opportunity__c in
(Select opportunityid from quote where status = 'Approved' or status= 'In Review') order by createddate desc limit 8000]; 
*/
        
    }
    
    @AuraEnabled
    public static void oppTeam(String email) {
        
        
        
        //
        
        User userinfo = [Select id, AccountId from user where email =:  email];
        
        List<Opportunity> opps = [Select id, ownerid, owner.email from opportunity where 
                                   id in (Select opportunity__c from opportunity_partner__c where (partner_account__r.owner.email  =: email 
                                         or opportunity__r.account.owner.email = : email)) order by lastmodifieddate desc limit 2000];
        
       
        
        
        List<OpportunityTeamMember> team = new List<OpportunityTeamMember>();
        
        for(Opportunity p : opps){
            OpportunityTeamMember t = new OpportunityTeamMember(opportunityId = p.Id,
                                                                userid = userinfo.Id,
                                                                OpportunityAccessLevel = 'Edit',
                                                                TeamMemberRole = 'TM'
                                                               );
            
            team.add(t);
            
        }          
        
        
        try{
            database.insert(team, false);
        }catch(Exception e){
            system.debug('there is an exception');
        }
        
        system.debug('team');
        system.debug(team);
        /*
        List<opportunity_partner__c> parts = [Select id, opportunity__c,Quote__c from opportunity_partner__c
        where partner_account__c = : userinfo.Accountid and opportunity__c in
        (Select opportunityid from quote where status = 'Approved' or status= 'In Review') order by createddate desc limit 8000]; 
        */
      	  
    }
    
    
}