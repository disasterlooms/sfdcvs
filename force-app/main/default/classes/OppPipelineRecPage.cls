public class OppPipelineRecPage {
     @AuraEnabled
    public static List<Opportunity> getPipe(String recid,String oppfields, String prodfields,String clause)
    {    
        //get account fields from contact and account
        //need to determine account type also need all parent child account
        //relationships to add to list when querying opportunity partner or 
        //opportunity ...may do opp partner object and cross query either partner and/or
        //end user could be where opportunity__r.Accountid in: accts Or Account__c in : accts
        //
        //also need to query for stage, only show open opps, not closed opps. They can use reports for open and close
        //otherwise there will be too many
        //
        //get report button, would be a nice add on
        
        
        //if is end user, query all related pipeline
        //related pipeline is not spa and is related to parent or child accounts
        
        Set<Id> accts = new Set<Id>();
        Set<Id> oppids = new Set<Id>();
        
        if(recid.substring(0,3) == '001'){
            //this is an account
            List<Account> accounts = [Select ID, Type,ParentId from Account where ParentId = : recid or Id =: recid ];
            for(Account a : accounts){
                accts.add(a.Id);
                if(a.ParentId != null){
                  accts.add(a.ParentId);
              }
            }
         }
        
        if(recid.substring(0,3) == '003'){
             //this is an contact
            List<Contact> contacts = [Select AccountId, Account.Type,Account.ParentID from Contact where Id = : recid];
            //add the opportunity ids where contact relates to an opportunity
            List<OpportunityContactRole> conopp = [Select OpportunityID from OpportunityContactRole where ContactId = : recid];
            for(OpportunityContactRole o : conopp){
                oppids.add(o.OpportunityID);
                
            }
            //add the account ids to the account for query
            for(Contact c : contacts){
                accts.add(c.AccountId);
                if(c.Account.ParentId != null){
                accts.add(c.Account.ParentId);
              }
            }
         }
        
        //go through lists and get the parent account ids from all accounts
        List<Account> parents = [Select Parent.Id from Account where Id in: accts and Parent.Id != null ];
        for(Account a: parents){
            accts.add(a.Id);
        }
    	
    	List<Opportunity_Partner__c> partners = [Select  Opportunity__c from Opportunity_Partner__c where Account_Id__c in: accts];
        for(Opportunity_Partner__c op : partners){
            oppids.add(op.opportunity__c);
        }
        
        String shipped = 'Shipped';
        system.debug('Select '+oppfields+',(Select '+prodfields+                                             
                      ' from OpportunityLineItems where Status__c != \'' + String.escapeSingleQuotes(shipped)+'\' ) from Opportunity where (AccountId in: accts or Id in: oppids)'+
                       ' '+ String.escapeSingleQuotes(clause)+' order by CloseDate desc limit 30');
        
        List<Opportunity> oppsToReturn = Database.query('Select '+oppfields+',(Select '+prodfields+                                             
                      ' from OpportunityLineItems where Status__c != \'' + String.escapeSingleQuotes(shipped)+'\' ) from Opportunity where (AccountId in: accts or Id in: oppids)'+
                       ' '+ String.escapeSingleQuotes(clause)+' order by CloseDate desc limit 30');
        system.debug('opps returning '+oppsToReturn);
        
      	return oppsToReturn;
    }
    @AuraEnabled
     public static User getUser()
    {     
        
         return getUser.getUser();
    }
    @AuraEnabled
    public static List<String> getStatus()  
  {   
      return GetProductStatus.getStatus();
    }
    @AuraEnabled
   public static List<Opportunity> updateopps(List<Opportunity> opps,List<OpportunityLineItem> lines){  
    
        //save the opportuntiy and line items in collections after clicking on save
     
       String  errormessages = '';
       Integer numerrors = 0;
       Integer numsuccess = 0;
       Integer numopps = 1;
        
        List<Database.SaveResult> updateResults = Database.update(opps, false);
                for(Integer i=0;i<updateResults.size();i++){
                    if (updateResults.get(i).isSuccess()){
                        updateResults.get(i).getId();
                        system.debug('success id '+ opps.get(i).Name);
                        numsuccess += 1;
                
                    }else if (!updateResults.get(i).isSuccess()){
                        // DML operation failed
                        Database.Error error = updateResults.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        opps.get(i);//failed record from the list
                        system.debug('Failed ID '+opps.get(i).Name);
                        system.debug('Message '+ failedDML);
                        numerrors += 1;
                     }
                }
        
        system.debug('number of errors '+numerrors+ ' successes '+numsuccess);
        
        List<Database.SaveResult> updateResultsp = Database.update(lines, false);
                for(Integer i=0;i<updateResultsp.size();i++){
                    if (updateResultsp.get(i).isSuccess()){
                        updateResultsp.get(i).getId();
                        system.debug('success id '+ lines.get(i).Name);
                        numsuccess += 1;
                    }else if (!updateResultsp.get(i).isSuccess()){
                        // DML operation failed
                        Database.Error error = updateResultsp.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        lines.get(i);//failed record from the list
                        system.debug('Failed ID '+lines.get(i).Name);
                        system.debug('Message '+ failedDML);
                        numerrors += 1;
                     }
                }
        
       system.debug('number of errors '+numerrors+ ' successes '+numsuccess);
    
       return null;
 }
    @AuraEnabled
    public static List<OpportunityLineItem> delProd(String prodid,List<Opportunity> opps,List<OpportunityLineItem> lines,String product){  
    
       List<OpportunityLineItem> pline = [Select Id from OpportunityLineItem where id =: prodid];
       system.debug('line items delete'+pline);
       delete pline;
       return null; 
 } 
    

}