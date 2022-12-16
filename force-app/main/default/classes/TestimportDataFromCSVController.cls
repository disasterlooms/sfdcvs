@isTest
public class TestimportDataFromCSVController {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
   
    static String str = 'Sales Rep,Quota Assigned,Quota Attained,SPG Quota,SPG Attainment,Product Focus Quota,Product Focus Attainment\n'+UserInfo.getName()+',1,2,3,4,5,6';       

    public static String[] csvFileLines;
    public static Blob csvFileBody;
    Static testmethod void importDataFromCSVController(){
		
       
        
        
        Test.startTest();       
        csvFileBody = Blob.valueOf(str);
        String csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n'); 
        
       	
       
        PageReference myVfPage = Page.ImportAccounts;
        Test.setCurrentPageReference(myVfPage); // use setCurrentPageReference
        importDataFromCSVController ac = new importDataFromCSVController();
        
        ac.csvFileBody = csvFileBody;

        ac.importCSVFile();
       
        
        
        
        

    }
}