public class MyOpportunityPipeline {
    
@AuraEnabled
     public static User getUser()
    {     
         return getUser.getUser();
    }
    @AuraEnabled
     public static List<String> getReps()
    {     
         
        List<User> myReps = [Select Id,FirstName,LastName from User where ManagerId =:UserInfo.getUserId() or Manager.ManagerId =: UserInfo.getUserId()];
        
        List<String> reps = new List<String>();
        reps.add('All');
        
        for (User u : myReps) {
            reps.add(u.Firstname+' '+u.LastName);
        }         
        system.debug('reps'); 
        
        return reps;
    }
    
    @AuraEnabled
    public static List<Opportunity> getOpps(String product,String reseller,String enduser,String industry,String prodtype,String srep)
    {     
     
        List<String> usernames = new List<String>();
        if(srep == 'all' || srep == '' || srep == null){
            usernames = MyOpportunityPipeline.getReps();
            usernames.add(UserInfo.getFirstName()+' '+UserInfo.getLastName());           
        }else{
             usernames.add(srep);
        }         
        
        
        List<Opportunity> pipeline = new List<Opportunity>();
        
        //reseller is a long text field and the like part of query does not work if null
        //so if reseller is not blank, the code below ensures it will not show up in results
        //a workaround I know. I hope you enjoy it or update it. thanks some dev guy
        String nreseller = 'xxxxxxxxxxx';
        if(reseller == null || reseller == ''){
          nreseller = '';
        }
        //cleanse out the strings for proper query and avoiding sql injection

        reseller = stringQuery.cleanString(reseller);
        product  = stringQuery.cleanString(product);
        enduser  = stringQuery.cleanString(enduser);
        industry = stringQuery.cleanString(industry);
        prodtype = stringQuery.cleanString(prodtype);

        system.debug('reserler '+reseller);
        
        List<OpportunityLineItem> opps = [Select ProductCode,OpportunityId,Opportunity.Account.Name,Opportunity.StageName,name
               ,quantity,ServiceDate,unitprice,product2id,product2.name,opportunity.name,opportunity.Opportunity_Notes__c,
               opportunity.Project_or_Site_Information__c,opportunity.Manager_Note__c,opportunity.Resellers_and_Type__c,Ship_Out_Date__c,
               status__c ,PricebookEntry.Product2.Product_Pillar__c
               from OpportunityLineItem
               where
               Opportunity.Owner.Name in : usernames  AND
               Product2.Name Like :product AND
               (Opportunity.Account.Industry Like :industry) AND                           
               Opportunity.Name Like :enduser AND
               PricebookEntry.Product2.Product_Pillar__c Like :  prodtype AND                         
               (Opportunity.Resellers_and_Type__c Like  : reseller OR Opportunity.Resellers_and_Type__c = :nreseller) And
               Opportunity.StageName != 'Closed Won' AND
               Opportunity.StageName != 'Closed Lost'
               Order By  OpportunityId desc  NULLS last limit 100];
        
        Set<String> oppids = new Set<String>();
            for (OpportunityLineItem oline : opps) oppids.add(oline.opportunityId);
        
        
        pipeline =  [Select Id, StageName,Opportunity_Notes__c,Manager_Note__c,AccountId, Account.Name,Product_Name_Main__c,CloseDate
                      ,Project_or_Site_Information__c,name,Resellers_and_Type__c,Pricebook2Id ,Partner_Account_Search__c,ResellerContact__c,End_User_Contact__c,
                      Trade_Show_or_Marketing_Campaign__c,CampaignId,Product_Added__c,(SELECT name,Quantity,Product2Id,product2.Name,ServiceDate
                                        ,Ship_Out_Date__c,status__c FROM OpportunityLineItems 
                                        where product2.name Like :product  
                                        and status__c != 'Shipped'                                               
                                        order by product2.name)                         
                      from opportunity where id in: oppids order by CloseDate asc, id];
        
        return pipeline;
    }
    @AuraEnabled
    public static List<OpportunityLineItem> getSchedule(String product,String reseller,String enduser,
                                                        String industry,String prodtype,String srep,
                                                        Boolean myopps, Boolean likely, Boolean committed)
    {     
        
        system.debug('toggles '+myopps+likely+committed);
        List<String> usernames = new List<String>();
        
        
        
        if(srep == 'all' || srep == '' || srep == null){
            usernames = MyOpportunityPipeline.getReps();
            usernames.add(UserInfo.getFirstName()+' '+UserInfo.getLastName()); 
        }else{
            usernames.add(srep);
        }
        List<User> oppusers = [Select id, firstname, lastname from user];
        if(!myopps){
            for(user u : oppusers){
                usernames.add(u.firstname+' '+u.lastname);
            }
        }
        system.debug('sales reps in list '+usernames);
        system.debug('string srep '+srep);
        //User u = [Select Id from User where Id =:UserInfo.getUserId()];
        
        Date cm = System.today().toStartOfMonth().addDays(-1);
        //List<Opportunity> pipeline = new List<Opportunity>();
         system.debug('product schedule 1 '+product);
        //reseller is a long text field and the like part of query does not work if null
        //so if reseller is not blank, the code below ensures it will not show up in results
        //a workaround I know. I hope you enjoy it or update it. thanks some dev guy
        String nreseller = 'xxxxxxxxxxx';
        if(reseller == null || reseller == ''){
          nreseller = '';
        }
        //cleanse out the strings for proper query and avoiding sql injection

        reseller = stringQuery.cleanString(reseller);
        product  = stringQuery.cleanString(product);
        enduser  = stringQuery.cleanString(enduser);
        industry = stringQuery.cleanString(industry);
        prodtype = stringQuery.cleanString(prodtype);

        system.debug('product schedule 2'+product);
        
        List<OpportunityLineItem> oppprods = [Select ProductCode,OpportunityId,Opportunity.Account.Name,Opportunity.StageName,name,Likely_Purchase__c,
               quantity,ServiceDate,unitprice,product2id,product2.name,opportunity.name,opportunity.Opportunity_Notes__c,Opportunity.CloseDate,Opportunity.Owner.Name,
               opportunity.Project_or_Site_Information__c,opportunity.Manager_Note__c,opportunity.Resellers_and_Type__c,Ship_Out_Date__c,
               status__c ,PricebookEntry.Product2.Product_Pillar__c,(Select Id,ScheduleDate,Quantity,type from OpportunityLineItemSchedules where ScheduleDate > :cm order by ScheduleDate asc limit 12) 
               from OpportunityLineItem
               where HasSchedule = true AND
               Likely_Purchase__c =: likely AND
               Opportunity.recordtype.name != 'Inactive' AND
               Opportunity.Committed__c = : committed    and                           
               Opportunity.Owner.Name in: usernames  AND
               Product2.Name Like :product AND
               (Opportunity.Account.Industry Like :industry) AND                           
               Opportunity.Name Like :enduser AND
               PricebookEntry.Product2.Product_Pillar__c Like :  prodtype AND                         
               (Opportunity.Resellers_and_Type__c Like  : reseller OR Opportunity.Resellers_and_Type__c = :nreseller) And
               Opportunity.StageName != 'Closed Won' AND
               Opportunity.StageName != 'Closed Lost'
               Order By  Opportunity.CloseDate asc, OpportunityId desc  NULLS last limit 100];
      
        
        return oppprods;
    }
    @AuraEnabled
   public static String updateopps(List<Opportunity> opps,List<OpportunityLineItem> lines){  
        
      String errors = '';
      errors = UpdateOppsProducts.updateopps(opps,lines);
       
      return errors;
 }
     @AuraEnabled
   public static String updatesch(List<OpportunityLineItem> opps,List<OpportunityLineItemSchedule> lines){  
        
      String errors = '';
      errors = UpdateOppsSchedules.updateopps(opps,lines);
       
      return errors;
 }
    @AuraEnabled
   public static List<Date> getmonths(List<OpportunityLineItem> opps,List<OpportunityLineItemSchedule> lines){  
        
     
      List<Date> dates = months.getMonths();
       
      return dates;
 }
    @AuraEnabled
    public static List<String> getStatus()  
  {
        return GetProductStatus.getStatus();
    }
    @AuraEnabled
    public static List<String> getProducts()  
  {
      List<String> prods = new List<String>();  
      
      List<Product2> aproducts = [Select Id, Name from Product2 where isActive = true order by name asc];
      for(Product2 p : aproducts){
          prods.add(p.name);
      }
      
      system.debug('products active '+prods);
      
      return prods;
    }
     @AuraEnabled
    public static List<String> getProdTypes()  
  {
        
      return productTypes.getProdTypes();
    }
     @AuraEnabled
    public static String getPricebook(String oppid)  
  {
      String pricebook = '';
      List<Opportunity> opp = [Select id, pricebook2id from opportunity where id = : oppid];
      
      pricebook = opp[0].pricebook2id;
      
      return pricebook;
    }
   
    @AuraEnabled
    public static String newprod(String oppid,
                             String prodid,
                             Decimal quant,
                             Decimal spaprice,
                             String ship,
                             String status,
                             String compete)  
  {
               
      Date shpdt = Date.valueOf(ship);
      system.debug('opp '+oppid+ ' prod id '+prodid+' quan '+quant+' ship '+shpdt+' status '+status+' compete '+compete);
      //Opportunity opp = [Select Id, Pricebook2Id,Pricebook2.Name from Opportunity
                              //Where Id =:oppid Limit 1];
      
      
      //get the pricebook entry
      List<PriceBookEntry> pbe = [Select Id,unitprice,IsActive,product2.name,pricebook2.name from Pricebookentry 
                            where id  = : prodid
                            Limit 1];
      
      system.debug('pbe id '+pbe[0].Id);
      system.debug('pbe id '+pbe[0].IsActive);
      
      OpportunityLineItem line = new OpportunityLineItem(PriceBookEntryId = prodid,
                                            UnitPrice = pbe[0].unitprice,
                                            Quantity = quant,
                                            OpportunityId = oppid,
                                            Status__c = status,
                                            Ship_Out_Date__c= shpdt,
                                            Competitor_SKU__c = compete);
          
           
      system.debug('line info '+line);
      if(pbe[0].Isactive==false){
          throw new AuraHandledException('The product '+ pbe[0].product2.name+' is not active in the current price book of '+pbe[0].pricebook2.name);
      }else{
          insert line;      
      }
      
     
      return line.Id;
    }
    @AuraEnabled
    public static List<OpportunityLineItem> delProd(String prodid,List<Opportunity> opps,List<OpportunityLineItem> lines,String product){  
    
       List<OpportunityLineItem> pline = [Select Id from OpportunityLineItem where id =: prodid];
       system.debug('line items delete'+pline);
       //delete pline;
       return pline; 
 } 
     @AuraEnabled
    public static List<String> getIndustries()  
  {
       
       
     return industries.getIndustries();
    }
}