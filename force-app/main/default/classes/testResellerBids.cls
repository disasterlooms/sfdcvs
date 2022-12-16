@isTest
public class testResellerBids {
     @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }

    public static testMethod void testMyController() {
        Account a = [Select id from Account limit 1];
        Contact c = new Contact(lastName = 'testcontact',email='coolemail@mail.com',
                               AccountId = a.Id);
        insert c;
        
        PageReference pageRef = Page.ResellerBids;
        Test.setCurrentPage(pageRef);
      
        ExternalEmailMatch cont = new ExternalEmailMatch();
        pageRef.getParameters().put('searchText',null);
        //test for null value
        cont.submit();
        ExternalEmailMatch cont2 = new ExternalEmailMatch();
        //test for email that don't exist
        pageRef.getParameters().put('searchText', 'someemaildontexthop@nowayemailjose.com');
        cont2.submit();
        //test for valid email
        ExternalEmailMatch cont3 = new ExternalEmailMatch();
        pageRef.getParameters().put('searchText', c.Email);
        cont3.submit();
        
        pageRef.getParameters().put('endusername', 'new end user');
        pageRef.getParameters().put('enduserstreet', '123 main st');
        pageRef.getParameters().put('enduserstate', 'ca');
        pageRef.getParameters().put('endusercity', 'some city');
        pageRef.getParameters().put('enduserzip', '90809');
        pageRef.getParameters().put('distributors', 'ingram');
        pageRef.getParameters().put('products', 'xgcoolprod');
        //pageRef.getParameters().put(quantity, 555);
        //pageRef.getParameters().put(closedate, date.today()+44);
        cont.quote();

        
    }
}