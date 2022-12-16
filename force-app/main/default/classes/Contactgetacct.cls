public class Contactgetacct {
    Contact con {get;set;}
    Account acc{get;set;}
    public String street {get;set;}
    public String city {get;set;}
    public String state {get;set;}
    public String zip {get;set;}
    public String country {get;set;}
    public String phone {get;set;}
    //constructor for extension
    public Contactgetacct(ApexPages.StandardController stdController){
        con = (Contact)stdController.getRecord();
       
      //pull the opportunity line items that were created and linked to this eval. Must use button on opportunity page to pull the data from opportunity
      List <Account> acc = [SELECT ID,BillingStreet,BillingCity,BillingState,Phone,
                            BillingPostalCode, BillingCountry FROM Account WHERE Id = :ApexPages.currentPage().getParameters().get('accid') limit 1];
        for(Account a : acc){
            street = a.BillingStreet;
            city = a.BillingCity;
            state = a.BillingState;
            zip = a.BillingPostalCode;
            country = a.BillingCountry;
            phone = a.phone;
        }
        system.debug(acc);
        system.debug(acc.size());
        system.debug(street+' '+city+' '+state+' '+zip+' '+country);
    }
}