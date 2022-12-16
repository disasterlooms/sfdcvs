public class OppTeams {
    //Apex properties or variables

    public Id Id { get; set; }
    public Opportunity opp { get; set; }

    //constructor to get the Case record
    public OppTeams(ApexPages.StandardController controller) {
    opp =  (Opportunity) controller.getRecord();
    Id = opp.Id;
    System.debug('The case record: ' + opp);
    }

    //Method that can is called from the Visual Force page action attribute
     //@InvocableMethod(label='Update Teams' description='Updates Opportunity Team Members')
    
    public PageReference updateteam() {
        List<Opportunity> opps = new List<Opportunity>();
        opps.add(opp);
        
        List<OpportunityTeamMember> teamdel = [select Id,OpportunityId,Opportunity.AccountId from OpportunityTeamMember
                where OpportunityId =:opp.id];

                delete teamdel;
        
        Boolean runrules = true;
        OpportunityTeamAdd.teams(opps,runrules);
        
        //System.debug('Opp Id: ' + Id);
        //Create list and add related accounts
        //by going through opp partners and end user account
        
        //add the end user account as will to update the account team
        
        
        //update account teams on related accounts
        
        //remove all team members\
        


        List<OpportunityTeamMember> oppTeamtoInsert = new List<OpportunityTeamMember>();


        //add RBM and director  based on End User State if it is not an etail retail account and TM if the End user
        //is from education
        //for (Opportunity  o : [select Id,StateLookup__r.RBM__c,
                                //End_User_Lookup_Account__c,End_User_Lookup_Account__r.Account_Type__c ,
                                //End_User_Lookup_Account__r.Industry,  Partner_Account_Search__c, 
                                //Partner_Account_Search__r.Account_Type__c,StateLookup__r.Director_RBM__c,
                                //StateLookup__r.Director_TM__c, StateLookup__r.Territory_Manager__c
                                //from Opportunity where id =: opp.id  ]){
        
           // OpportunityTeamMember rbm = new OpportunityTeamMember(
                                                       // OpportunityId = o.Id, 
                                                        //TeamMemberRole = 'RBM',
                                                        //UserId = o.StateLookup__r.RBM__c,
                                                        //OpportunityAccessLevel = 'Edit'    
                                                   // ); 
        
            //if(o.StateLookup__c != null && o.Partner_Account_Search__r.Account_Type__c != 'Retail/Etail'){

            //OpportunityTeamMember rbm = new OpportunityTeamMember(
                                            //OpportunityId = o.Id, 
                                            //TeamMemberRole = 'RBM',
                                            //UserId = o.StateLookup__r.RBM__c,
                                            //OpportunityAccessLevel = 'Edit'    
                                        //); 

                                          //oppTeamtoInsert.add(rbm); 
                                      
            //OpportunityTeamMember rbmdir = new OpportunityTeamMember(
                                            //OpportunityId = o.Id, 
                                            //TeamMemberRole = 'Manager/Director',
                                            //UserId = o.StateLookup__r.Director_RBM__c,
                                            //OpportunityAccessLevel = 'Edit'    
                                       // ); 

                                         // oppTeamtoInsert.add(rbmdir); 

             //if(o.End_User_Lookup_Account__r.Industry == 'Education'){
                    //OpportunityTeamMember tm = new OpportunityTeamMember(
                                            //OpportunityId = o.Id, 
                                            //TeamMemberRole = 'TM',
                                            //UserId = o.StateLookup__r.Territory_Manager__c,
                                            //OpportunityAccessLevel = 'Edit'    
                                        //); 

                                          //oppTeamtoInsert.add(tm); 
                                      
                    //OpportunityTeamMember tmdir = new OpportunityTeamMember(
                                            //OpportunityId = o.Id, 
                                            //TeamMemberRole = 'Manager/Director',
                                            //UserId = o.StateLookup__r.Director_TM__c,
                                            //OpportunityAccessLevel = 'Edit'    
                                        //); 

                                          //oppTeamtoInsert.add(tmdir); 
                                      //}

                                    //}
        


            //Get all the opportunity partners and query them and put the account Id in the list for each
            //Then query all account team  members that are on in the new string list of accounts in partners
            //before adding them to a list to insert, ensure the user id is active

            //Set<String> accts = new Set<String>();
                //for (Opportunity_Partner__c mem : [
                    //Select Id, Partner_Account__c, Opportunity__c ,Partner_Account__r.Id from Opportunity_Partner__c
                    //where Opportunity__c =:opp.id]) accts.add(mem.Partner_Account__c);
            
            //for(AccountTeamMember team : [Select UserId ,TeamMemberRole,User.IsActive from AccountTeamMember where AccountId IN : accts]){

                    //if(team.User.IsActive  ==true){
                        //OpportunityTeamMember resteam = new OpportunityTeamMember(
                                           // OpportunityId = opp.Id, 
                                            //TeamMemberRole =  team.TeamMemberRole,
                                            //UserId = team.UserId,
                                            //OpportunityAccessLevel = 'Edit'    
                                     //   ); 

                                          //oppTeamtoInsert.add(resteam); 


                   // }
                    

            //} 
                                                
                            //insert oppTeamtoInsert;


        //}



      List<Quote> q = [Select id from Quote where opportunityid =: Id order by createddate desc limit 1];
        
       Id redir = opp.Id;

        if(q.size() > 0){
            redir = q[0].id;
        }else{
            redir = opp.Id;
        }         
       
        
       //PageReference pageRefquote = new PageReference('/'+q[0].Id);
        
       PageReference pageRef = new PageReference('/'+redir);
       
       pageRef.setRedirect(true);
        
        
       return pageRef; //Returns to the opp page
    }
}