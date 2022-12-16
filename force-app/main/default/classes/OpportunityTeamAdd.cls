public class OpportunityTeamAdd {
    public static void teams(List<Opportunity> opps, Boolean runAcctTeam) {
        
        //create a set of accounts to prevent duplicate account teams from 
        //being updated then get all partner accounts and end user accounts in a list that can be
        //used to update account teams and then opportunity teams
        
        system.debug('Opp Teams Add is now running ');
        
        List<Opportunity> oppsRelated = [Select id, AccountId , (Select Partner_Account__c from Opportunity_Partners__r) from Opportunity where id in : opps];
        system.debug('opp teams related opps info');
        system.debug(oppsRelated.size());
        String quote = '';
        
        List<Quote> qts = new List<Quote>();
        String qid = '';
        Map<String,Quote> quotes = new Map<String, Quote>();
        Map<String,Quote> quotesEU = new Map<String, Quote>();        
         
        for(Quote q : [Select Id , OpportunityId,Opportunity.AccountId,Opportunity.Ownerid, Resubmitter__c, Spa_Request_Submitter__c  
                       from Quote where OpportunityId in: opps order by CreatedDate asc]){
                           quotes.put(q.OpportunityId , q);
                           qts.add(q);
                           system.debug('the opp id');
                           system.debug(q.OpportunityId);
                           system.debug('the end user id');
                           system.debug(q.Opportunity.AccountId);
                           quotesEU.put(q.Opportunity.AccountId, q);
                           if(q.Id != null){
                               qid = q.Id;
                           }
                       }
        
        
        // qid is for error tracking Prefer to use the quote id but in insert trigger id does not exist so use the opportunity id in that case
        // 
        if(qid == null ){
            qid = opps[0].Id;
        }
        
                
        List<Account> PartEUAccts = [Select Id,Type,Industry,BillingState,Name,
                                     BillingCountry,OwnerId , (Select id, userid,accountid,teammemberrole
                                                               from AccountTeamMembers ) from Account where id in (Select Partner_Account__c from Opportunity_Partner__c
                                                                                                                   where Opportunity__c in: opps)];
        
        List<Account> EU = [Select id, (Select id, userid,accountid,teammemberrole
                                        from AccountTeamMembers) from Account where Id in: quotesEU.keySet() ];
        for(Account a : EU){
            PartEUAccts.add(a);
        }
       
        //run account teams but if there is an error document the error and then move on
        //and update the opp team as close as possible. 
        
        List<Account> EUNull = new List<Account>(); 
        
         List<AccountTeamMember> aTeams = new List<AccountTeamMember>();
        
        if(runAcctTeam == true){
            aTeams = AccountTeamAdd.teams(PartEUAccts);
            system.debug('account team for opp ');
            system.debug(aTeams);
        }else{
            try{                
                
                     aTeams = AccountTeamAdd.teams(PartEUAccts);
                             
            }catch(Exception e){
                String recId = qid;
                String objType  ='AccountTeamMember';
                String apexClass ='AccountTeamAdd.teams';
                String errMessage = e.getmessage();
                apexerrorlog.logError(recId, objType, apexClass, errMessage);
                for(Account a : PartEUAccts){
                    ateams.addAll(a.AccountTeamMembers);
                } 
            }
            
            
            // aTeams = [Select id, userid,accountid,teammemberrole
                    //  from AccountTeamMember where accountid in : accounts and userid != null];
        }
       
        system.debug('the account teams list and size ');
        system.debug(aTeams);
        system.debug(aTeams.size());
        
        
        
        //List<AccountTeamMember> aTeams = [Select Id,UserId,AccountId,TeamMemberRole from AccountTeamMember
                                         //where AccountId in : accounts];
        //delete the current opp team
        
                
        List<OpportunityTeamMember> teamdel = [select Id,OpportunityId from OpportunityTeamMember
                where OpportunityId in: opps];

        database.delete(teamdel, false);
        
        // may need to add code to test if delete failed. this could be an issue 
        
        List<OpportunityTeamMember> oppTeamtoAdd = new List<OpportunityTeamMember>();
        List<OpportunityTeamMember> oppTeamtoInsert = new List<OpportunityTeamMember>();
        
        //get list account ids from opps and loop through them for account teams
        //and repeat for opportunity partners
        
        /*
        List<Opportunity> euacct = [Select ID, AccountId,(Select Id from Quotes order by CreatedDate desc) from Opportunity
                                              where Id in: opps];
        */
        
        //for(Opportunity o : euacct){
        
        system.debug('size of the Spa EU Map ' + quotesEU.size());
        system.debug(quotesEU.keySet());
        
        
        for(Opportunity o : oppsRelated){
            for(AccountTeamMember atmeu : aTeams ){             
                if(o.AccountId == atmeu.AccountId ){
                     OpportunityTeamMember euteam = new OpportunityTeamMember(
                         OpportunityId = o.Id,TeamMemberRole = atmeu.TeamMemberRole,UserId = atmeu.UserId,OpportunityAccessLevel = 'Edit');
                    oppTeamtoAdd.add(euteam);
                }
            }
            for(Opportunity_Partner__c op : o.Opportunity_Partners__r){
                for(AccountTeamMember atmeu : aTeams ){             
                    if(op.Partner_account__c == atmeu.AccountId ){
                        OpportunityTeamMember euteam = new OpportunityTeamMember(
                            OpportunityId = o.Id,TeamMemberRole = atmeu.TeamMemberRole,UserId = atmeu.UserId,OpportunityAccessLevel = 'Edit');
                        oppTeamtoAdd.add(euteam);
                    }
                } 
            }
            
        }
        for(Quote q : qts ){
            if(q.Resubmitter__c != null){
                OpportunityTeamMember Submitter = new OpportunityTeamMember(
                    OpportunityId = q.OpportunityId, 
                    TeamMemberRole = 'Quote Submitter',
                    UserId = q.Resubmitter__c,
                    OpportunityAccessLevel = 'Edit'    
                );
                oppTeamtoAdd.add(Submitter);
            }
            
            if(q.Spa_Request_Submitter__c != null){
                OpportunityTeamMember reSubmitter = new OpportunityTeamMember(
                    OpportunityId = q.OpportunityId, 
                    TeamMemberRole = 'Quote Submitter',
                    UserId = q.Spa_Request_Submitter__c,
                    OpportunityAccessLevel = 'Edit'    
                );
                oppTeamtoAdd.add(reSubmitter);
                
            }
            
        }     
        
        

        //
        // owner id field is null... because the field is not passed,, need to use quote id field instead..  probably using the map from quotes
        //
        //  
        //ensure ownerid is on team
        for(Quote q : qts){
            
            OpportunityTeamMember owner = new OpportunityTeamMember(
                                                        OpportunityId = q.OpportunityId, 
                                                        TeamMemberRole = 'Owner',
                                                        UserId = q.Opportunity.OwnerId,
                                                        OpportunityAccessLevel = 'Edit'    
                                                    );
             oppTeamtoAdd.add(owner);
        }
        
        //going to loop through these teamadd list and put in map and then create a new list to ensure there
        //are no duplicates in this list that may cause an insert error
        //
        //There are some UserIds that are blank in the error message, removing that from the final 
        //list.. also will work to isolate where they are coming from
        //
        
        system.debug('the team to add LIst');
        system.debug(oppTeamtoAdd);
        
        Map<String,OpportunityTeamMember> oTeam = new Map<String,OpportunityTeamMember>();
        for(OpportunityTeamMember ot : oppTeamtoAdd){
            if(ot.UserId != null ){
                String ou = String.valueOf(ot.OpportunityId) +String.valueOf(ot.UserId);
                oTeam.put(ou, ot);   
            }
            
        }
        
        system.debug('the team to add List to map results');
        system.debug(oTeam);
        system.debug(oTeam.size());
        
        for(OpportunityTeamMember otm : oTeam.values()){
            system.debug('running oteam and adding to quote id'); 
            if(quotes.containsKey(otm.OpportunityId)){
                system.debug('the quote is here ');
                Quote q = quotes.get(otm.OpportunityId);
            	 otm.Quote__c = q.Id;
            }           
            oppTeamtoInsert.add(otm);
        }
        
        system.debug('the team to add Map to list results team to insert');
        system.debug(oppTeamtoInsert);
        system.debug(oppTeamtoInsert.size());
        
        // trying to add all, if it fails, will add the first quote id into the apex error object to monitor and decide how to 
        // resolve. Then doing a database insert to get as close as possible. This is to reduce the amount of sales reps missing on 
        // a potential spa. 
        // 
        
        try{
            insert oppTeamtoInsert;
        }catch(Exception e){
            String recId = qid;String objType  ='OpportunityTeamMember';String apexClass ='OpportunityTeamAdd';String errMessage = e.getmessage();
            apexerrorlog.logError(recId, objType, apexClass, errMessage);database.insert(oppTeamtoInsert,false);
        }
        
    }

}