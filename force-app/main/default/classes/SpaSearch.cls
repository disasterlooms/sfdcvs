public class SpaSearch {
    @AuraEnabled
     public static User getUser()
    {     
         Id userId = UserInfo.getUserId();
        
         return [SELECT Name,Country FROM User WHERE Id = :userId];
    }    
    @AuraEnabled
    public static List<Opportunity> getSpas(String product,String reseller,String enduser,
                                            String industry,String ofields,String pfields,
                                           String family, String spaid)
    {     
     
        String prodsearch = '%'+product+'%';
        if(reseller == null || reseller == ''){
            reseller='%%';
        }else{
            reseller =  '%'+reseller+'%';
        }
         if(product == null || product == ''){
            product='%%';
        }else{
            product =  '%'+product+'%';
        }
        
        if(enduser == null || enduser == ''){
            enduser='%%';
        }else{
            enduser =  '%'+enduser+'%';
        }
        if(industry  == null || industry == '' || industry =='--None--'){
            industry='%%';
        }else{
            industry =  '%'+industry+'%';
        }
        if(family  == null || family == '' || family =='--None--'){
            family='%%';
        }else{
            family =  '%'+family+'%';
        }
        if(spaid  == null || spaid == '' || spaid =='--None--'){
            spaid='%%';
        }else{
            spaid =  '%'+spaid+'%';
        }

        
       List<OpportunityLineItem> opps = [Select ProductCode,OpportunityId,Opportunity.Account.Name,Opportunity.StageName,name
             ,quantity,ServiceDate,unitprice,product2id,product2.name,opportunity.name,opportunity.Opportunity_Notes__c,
             opportunity.Project_or_Site_Information__c,opportunity.Manager_Note__c,opportunity.Resellers_and_Type__c,Ship_Out_Date__c,status__c 
             from OpportunityLineItem
             where
             Opportunity.OwnerId = : UserInfo.getUserId() AND
             Product2.Name Like :product AND
             Opportunity.SPA_ID__c Like :spaid AND                            
             Opportunity.Account.Industry Like :industry AND                           
             Opportunity.Name Like :enduser AND
             Product2.Product_Line__r.Name Like :family AND                            
             (Opportunity.Resellers_and_Type__c Like  : reseller OR Opportunity.Resellers_and_Type__c = null)
             Order By  OpportunityId desc  NULLS last limit 150];
        
        Set<String> oppids = new Set<String>();
            for (OpportunityLineItem oline : opps) oppids.add(oline.opportunityId);
        
        
         List<Opportunity> spasToReturn = Database.query('Select '+ofields+',(Select '+pfields+                                             
                      ' from OpportunityLineItems) from opportunity where ID in: oppids '+
                       'and Spa_Stage__c != null limit 25');
        
        
         return spasToReturn;
    }
    @AuraEnabled
   public static List<Opportunity> updateopps(List<Opportunity> opps,String product){  
    
        //save the opportuntiy and line items in collections after clicking on save
     
       String  errormessages = '';
       Integer numerrors = 0;
       Integer numsuccess = 0;
       Integer numopps = 1;
        
        List<Database.SaveResult> updateResults = Database.update(opps, false);
                for(Integer i=0;i<updateResults.size();i++){
                    if (updateResults.get(i).isSuccess()){
                        updateResults.get(i).getId();
                        //system.debug('success id '+ opps.get(i).Name);
                        numsuccess += 1;
                
                    }else if (!updateResults.get(i).isSuccess()){
                        // DML operation failed
                        Database.Error error = updateResults.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        opps.get(i);//failed record from the list
                        //system.debug('Failed ID '+opps.get(i).Name);
                        system.debug('Message '+ failedDML);
                        numerrors += 1;
                     }
                }
        
       system.debug('number of errors '+numerrors+ ' successes '+numsuccess);
       
       return opps;
 } 
    @AuraEnabled
    public static List<String> getStatus()  
  {
        List<String> options = new List<String>();
        options.add('--None--');
        Schema.DescribeFieldResult fieldResult = OpportunityLineItem.Status__c.getDescribe();
    
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    
        for (Schema.PicklistEntry f: ple) {
            options.add(f.getValue());
        } 
        system.debug('options');      
       
      return options;
    }
     @AuraEnabled
    public static List<String> getProdTypes()  
  {
        List<String> options = new List<String>();
        options.add('--None--');
        
        List<Product_Manager__c> pillars = [Select Id, Name from Product_Manager__c];
    
        for (Product_Manager__c p: pillars) {
            options.add(p.name);
        } 
        system.debug('options');      
       
      return options;
    }
     @AuraEnabled
    public static List<String> getIndustries()  
  {
        List<String> options = new List<String>();
        options.add('--None--');
        Schema.DescribeFieldResult fieldResult = Account.Industry.getDescribe();
    
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    
        for (Schema.PicklistEntry f: ple) {
            options.add(f.getValue());
        } 
        system.debug('options');      
       
      return options;
    }

}