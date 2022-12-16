public class acctspalist {
    
    public List<Opportunity> oppz;
      Account acc {get;set;} 
         
     //constructor for extension
    public acctspalist(ApexPages.StandardController stdController){
    acc = (Account)stdController.getRecord();
          
    }
}