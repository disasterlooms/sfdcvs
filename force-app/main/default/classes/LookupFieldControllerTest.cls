@isTest
public class LookupFieldControllerTest {
    
    @isTest
    public static void test() {
        List<PriceBook2> pricebooks = new List<PriceBook2>();
            
            PriceBook2 pb = new Pricebook2(Name='VSA Distributor Price List',IsActive=true);
            pricebooks.add(pb);
            
            insert pricebooks;
        
        
        LookupFieldController.getInfo('Account');
		LookupFieldController.getInfo('User');        
        LookupFieldController.generateQuery('case', 'test', false,pb.id);
        LookupFieldController.generateQuery('contact', 'test', false,pb.id);
        LookupFieldController.generateQuery('lead', 'test', false,pb.id);
        LookupFieldController.generateQuery('contract', 'test', false,pb.id);
        LookupFieldController.generateQuery('order', 'test', false,pb.id);
        LookupFieldController.generateQuery('product2', 'test', false,pb.id);
        LookupFieldController.generateQuery('orderItem', 'test', false,pb.id);
        LookupFieldController.generateQuery('user', 'test', false,pb.id);
        LookupFieldController.generateQuery('pricebookentry', 'test', false,pb.id);
        
        LookupFieldController.showRecentViewed('contact',pb.id);
        LookupFieldController.obtainObjectById('', 'contact');
        LookupFieldController.obtainObjectList('test', 'contact',pb.id);
        
        String expected = 'SELECT Id,CaseNumber,Subject FROM case  WHERE LastViewedDate != null ORDER BY LastViewedDate DESC  LIMIT 5';
        String testQuery = LookupFieldController.generateQuery('case', '', true,pb.id);
        System.assertEquals(expected, testQuery);
    }
    
}