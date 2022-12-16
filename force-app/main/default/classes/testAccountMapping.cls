@isTest
public class testAccountMapping {
     @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }

    public static testMethod void testMyMaps() {
        test.startTest(); 
        Account a = [Select id, name, billingcity,billingstate,BillingPostalCode,industry,annualrevenue,
                    phone,Type,District_Classroom_Count__c,County__c from account order by name desc limit 1 ];
        
        
        
        School__c sc = new School__c(account__c = a.Id,
                                    name = 'test school',
                                    DistrictId__c = '123');
        insert sc;
        
        String city = a.billingcity;
        String state = a.billingstate;
        String zip = a.BillingPostalCode;
        System.debug('zip '+zip);
        String ind = a.Industry;
        String acctType = '';
        Double classSize = 0;
        Double rev = 0;
        Boolean focus = false;
        String limitstmnt = 'limit 5';
        String orderstmnt = 'order by name desc';
        String wherestmnt = '';
        Double rank = 0;
        String county = a.County__c;
        
        if(zip==null){
           a.billingpostalcode = '123';
          
           zip = '12';
        }
        
        if(county==null){
           a.county__c = 'count';
           
           county = 'cou';
        }
        
         if(acctType==null){
           a.Type = 'End User';
           
           acctType = 'End User';
        }
        
        if(rev == null){
            rev = 0;
        }
        
         if(classSize == null){
            classSize = 0;
        }
        
         if(rank == null){
            rank = 0;
        }
        
        update a;
        System.debug('zip '+zip);  
		
        List <Account> accts = getAccountsMap.getaccts(city, state, zip, ind, acctType, classSize, rev, focus, rank, limitstmnt, orderstmnt, wherestmnt,county);        
        List<School__c> schls = getAccountsMap.getSchoolssMap(accts);
        
        test.stoptest();
        
        system.assertEquals(accts[0].Id, a.Id);
        system.assertEquals(schls[0].account__c, a.Id);
        
        
    }
}