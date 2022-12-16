@isTest
private class testPPSerialUploadCSV{
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void TestposSerial() {
        
        test.startTest();
        Account a = [Select id from account limit 1];
        Asset ass = new Asset();
        ass.AccountId = a.Id;
        ass.SerialNumber = 'testing123letsgo';
        ass.Name = 'testing123letsgo';
        ass.SerialLine__c = 'testing123letsgo';
        ass.PurchaseDate = date.today();
        ass.name ='test';
        insert ass;
        String spiff = [Select Name from spiff_request__c limit 1].Name;

        String str = 'SerialNumber,Spiff Request\ntesting123letsgo,'+spiff+
        '\nserailnumber2,spiff223';
        Blob csvFileBody = Blob.valueOf(str);

        ContentVersion cv1 = new ContentVersion(
                Title='SampleTitle', 
                PathOnClient ='SampleTitle.csv',
                VersionData = csvFileBody, 
                origin = 'H'
            );
            insert cv1;
            
           //String versId = cv1.Id; 
           ContentVersion vers =  [Select id, contentDocumentId from ContentVersion
           where id =:cv1.Id
           limit 1]; 
            String contid = vers.contentDocumentId;
            system.debug('the content version id '+ cv1.Id+' document Id '+contid);
            String recordId = [Select id from spiff_request__c limit 1].Id;
            try{
                fileUploadCSV.csvFileRead(contid,recordId);
            }catch(Exception ex){
                system.debug('there was an excption on the insert with record id'+ ex.getMessage());
            }
            recordId = null;
            system.debug('cv1 id '+ cv1.Id);
            try{
                fileUploadCSV.csvFileRead(contid,recordId);
            }catch(Exception ex){
                system.debug('there was an excption on the insert without recordid '+ ex.getMessage());
            }
            

        Test.stopTest();
        
        
        
    }
}