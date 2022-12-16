public class oppadddistis {
    @auraEnabled
    public static List<Account> getDistis(String recid){
        String country = '';
        Opportunity opp = new Opportunity();
        
        //getting the coutnry from the opporutniyt. sometimes reps do deals accross regions and best to 
        //use the opportunity field but if user is part of portal will look at country.
        //as this scales, we may need to add a region field from the User field to get the correct
        //list of distributors
        String viewsonic = '';
        try{
            opp = [Select id, Country__c from Opportunity where id = :recid];
            country = '%'+opp.Country__c+'%';
            if(opp.Country__c != 'Canada' && opp.Country__c != 'United States'){
                country = '%%';
            }
        }catch(Exception e){
            User u = [Select id , country from user where id =: Userinfo.getuserid()];country = u.Country;viewsonic = 'ViewSonic Corporation';
            
        }
        
        
        system.debug(opp);
        
        
        system.debug(country);
        List<Account> distis = [Select id, name, BillingStreet,BillingCity,Billingcountry,Type,
                               BillingState, phone, industry from account where (Auto_Create_Disti__c = true
                                and BillingCountry like : country) or name =: viewsonic  order by name asc];
        system.debug(distis);
            
        return distis;
    }
    
    @auraEnabled 
    public static void addDistis(List<Opportunity_Partner__c> distis){
        
        insert distis;
    }
}