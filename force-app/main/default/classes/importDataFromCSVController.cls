public class importDataFromCSVController {
public Blob csvFileBody{get;set;}
public string csvAsString{get;set;}
public String[] csvFileLines{get;set;}
public List<Quota__c> acclist{get;set;}
  public importDataFromCSVController(){
    csvFileLines = new String[]{};
    acclist = New List<Quota__c>(); 
  }
  
  public void importCSVFile(){
      List<Quota__c>quotatoupdate = new List<Quota__c>(); 
      
      List<Quota__c> quotas = [Select Id,Assigned_Quota__c,Quota_Attained__c,SPG_Quota__c,SPG_Attainment__c,
                       Product_Focus_Quota__c,Product_Focus_Attainment__c,Sales_Rep__c,Sales_Rep__r.Name
                        from Quota__c where Sales_Rep__c != null];
      system.debug(quotas.size());
      try{
           csvAsString = csvFileBody.toString();
           csvFileLines = csvAsString.split('\n'); 
            
           for(Integer i=1;i<csvFileLines.size();i++){
               Quota__c accObj = new Quota__c() ;
               string[] csvRecordData = csvFileLines[i].split(',');
               		for(Quota__c q : quotas){
                        system.debug('rep name '+q.Sales_Rep__r.Name+ ' row1name '+csvRecordData[0]);
                        if(q.Sales_Rep__r.Name == csvRecordData[0] && q.Sales_Rep__c!= null ){                            
                            accObj.Id = q.Id;
                            accObj.Assigned_Quota__c =  integer.valueOf(csvRecordData[1]) ;             
               				accObj.Quota_Attained__c = integer.valueOf(csvRecordData[2]);
              				accObj.SPG_Quota__c = integer.valueOf(csvRecordData[3]) ;             
               				accObj.SPG_Attainment__c = integer.valueOf(csvRecordData[4]);
               				accObj.Product_Focus_Quota__c = integer.valueOf(csvRecordData[5]) ;             
               				accObj.Product_Focus_Attainment__c = integer.valueOf(csvRecordData[6]);
                            quotatoupdate.add(accObj);
                            system.debug('csv name '+csvRecordData[0]+' record name '+q.Sales_Rep__r.Name);
                        }                                 
          			} 
               
               //acclist.add(accObj); 
           }
           system.debug(acclist);
          system.debug('update list' +quotatoupdate);          
          
           upsert quotatoupdate;
        }
        catch (Exception e)
            
        {
            system.debug(e);
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured while importin data Please make sure input csv file is correct. Must be csv file,'+
                                                                   'no blanks (replace with 0) and columns must be in order. Sales Rep - Quota Assigned - Quota Attained - SPG Quota - SPG Attainment'+
                                                                  ' - Product Focus Quota - Product Focus Attainment');
            ApexPages.addMessage(errorMessage);
        }  
  }
}