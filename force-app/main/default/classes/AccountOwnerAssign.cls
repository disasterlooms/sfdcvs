public class AccountOwnerAssign {
    public void assignAcctOwner(Account a) {
        /*
        String ownid = 'Blank';
        // Get State, Account Type, and Industry from Account
        // Then use that combination to get the owner of the record There 
        // Are really 3 types of Geos that we can auto assign
        // RBM, TM, and Pro AV aka Enterprise,Education,Pro AV
        String territoryrole = 'unknown';
        
        if(a.Industry.contains('Education')){
            territoryrole = 'Education';
        }else if(a.Industry == 'AV Solution'){
            territoryrole = 'Pro_AV';
        }else if(a.Type == 'End User'){
            territoryrole = 'Enterprise';
        }
        List<UserTerritory2Association>  uta = [SELECT Id,RoleInTerritory2,Territory2Id,UserId,  Territory2.Territory2ModelId, 
                                                Territory2.Territory2Model.name ,Territory2.Territory2Type.developername
                                                FROM UserTerritory2Association where Territory2.Territory2Type.developername =: territoryrole
                                                and RoleInTerritory2  ='Account Owner'];        
        
        String statecode = '%'+a.BillingStateCode+'%';
        String countys = '%'+a.County__c+'%';
        system.debug('code');
        system.debug(statecode);
        system.debug(uta);
        system.debug('counti '+countys);
        
        String field = 'testfield';
        List<RuleTerritory2Association> ruleass =[SELECT Id,RuleId,Territory2Id, Territory2.Territory2Type.DeveloperName,Territory2.Name,
                                                  Territory2.developername FROM RuleTerritory2Association where 
                                                  ruleid in (select RuleId FROM ObjectTerritory2AssignmentRuleItem where field = 'Account.BillingStateCode' and value like :statecode)];
        
        Map <String,RuleTerritory2Association> rta = new Map<String,RuleTerritory2Association>();       
        for(RuleTerritory2Association r :  ruleass){rta.put(r.Territory2Id, r);}
        
        Map<String,ObjectTerritory2AssignmentRuleItem> counties = new Map<String,ObjectTerritory2AssignmentRuleItem>();
        Map<String,ObjectTerritory2AssignmentRuleItem> notequalcounties = new Map<String,ObjectTerritory2AssignmentRuleItem>();
        
        for(ObjectTerritory2AssignmentRuleItem oar : [select id,RuleId,value,field,operation 
                                                      FROM ObjectTerritory2AssignmentRuleItem where (field = 'Account.County__c' and (operation = 'equals' or operation = 'contains')
                                                                                                     and value like :countys ) or ((operation = 'notEqual' or operation = 'notContain') and field = 'Account.County__c')]){
                                                                                                         if(oar.Operation == 'equals' || oar.Operation == 'contains'){counties.put(oar.RuleId,oar);   
                                                                                                         }else if(oar.Operation == 'notContain' || oar.Operation == 'notEqual'){notequalcounties.put(oar.RuleId,oar);}
                                                                                                     }
        
        
        
        
        Map<String,ObjectTerritory2AssignmentRuleItem> otar = new Map<String,ObjectTerritory2AssignmentRuleItem>();
        for(ObjectTerritory2AssignmentRuleItem ot : 
            [select RuleId,value,field FROM ObjectTerritory2AssignmentRuleItem where field = 'Account.County__c' and value like :statecode]){otar.put(ot.RuleId,ot);}
        
        
        system.debug('true value counties');
        system.debug(counties);
        
        system.debug('not equal value counties');
        system.debug(notequalcounties);
        system.debug(rta);
        Boolean County = false;
        
        if((a.Type == 'End User' &&
            a.billingStateCode.toLowerCase().contains('ca')) || (a.Industry.contains('Education') && a.billingStateCode == 'NY')){
                County = true;
                system.debug('need county');
            }
        
        system.debug(counties);
        system.debug('rulse with counties');
        for(UserTerritory2Association u : uta){
            
            if(rta.containsKey(u.Territory2Id)){
                if(!County){
                    ownid = u.UserId;
                    system.debug('user id '+u.UserId);
                }else{
                    RuleTerritory2Association ass = rta.get(u.Territory2Id);
                    system.debug('get value of ass as county is needed');
                    system.debug(ass.RuleId);
                    
                    if(notequalcounties.containsKey(ass.RuleId) ){
                        system.debug('found the correct county');
                        system.debug(u.UserId);
                        ownid = u.UserId;
                        
                    }else if(counties.containsKey(ass.RuleId)){
                        system.debug('County does not exist in the map');
                        ownid = u.UserId;
                        return ownid;
                    }
                }
                
                
            }          
            
        }        
        // make sure there is an assigment otherwise use the original owner given
        if(ownid == 'Blank'){
            ownid = a.OwnerId;
        }
        
        
        return ownid;
        */
    }
    
}