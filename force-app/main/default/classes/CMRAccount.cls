public class CMRAccount{
  
  // The one method your master trigcger will call
  public static void UpdateCmrSales() {

   /*   //get a new list of products that the landing costs have changed

    List<CMRSales__CMRCompany__c> euupdate = new List<CMRSales__CMRCompany__c>();
    List<CMRSales__CMRCompany__c> resupdate = new List<CMRSales__CMRCompany__c>();

    List<CMRSales__CMRCompany__c> cAcctChange = new List<CMRSales__CMRCompany__c>();
      for(CMRSales__CMRCompany__c c : newComps.values()){

        CMRSales__CMRCompany__c o  = oldComps.get(c.Id);
          if(o.CMRSales__Account__c == null && c.CMRSales__Account__c != null){ 

            c.SalesObjectUpdate__c = true;        

        


                       }
        } 

        if(!system.isFuture() && !system.isBatch()){ 
            UpdateCMRSalesReseller  myBatchObject1 = new UpdateCMRSalesReseller (); 
            Id batchId = Database.executeBatch(myBatchObject1);   

            UpdateCMRSalesEU myBatchObject2 = new UpdateCMRSalesEU(); 
            Id batchId2 = Database.executeBatch(myBatchObject2);  
         } 

         
        
        //send product list to future method so that the oppline items that need changed will be changed. 
        //String jsonString = json.serialize(plandchange);
        //ProductLandingCosts.UpdateOppLines(jsonString);
        */
    }
  }