@IsTest 
public class testCustomSearchController  {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    
    Static testmethod void searchTest() {
        test.startTest();
        String searchText = '';
        Integer qty = 20;
        String exclusion = '';
        String library = '';
        String category = '';
        Boolean spiffs = true;
        Boolean promos = false;
        Boolean pricing = false;
        
        CustomSearchController.searchForIds(searchText,qty,exclusion,library,category);
        String assId = '';
        String fileId = '';
        CustomSearchController.getContentVersion(assId);
        qty = null;
        CustomSearchController.getPromos(qty,spiffs,promos,pricing);
        library = 'Partner Portal Promotions';
        qty = 20;
        CustomSearchController.searchForIds(searchText,qty,exclusion,library,category);
        CustomSearchController.getFileId(fileId);
        test.stopTest();
       
    }
}