@isTest(SeeAllData=true)
private class testCreateFDServiceTicket {
    
    static testmethod void testdescriptionUpdate() {
        
        String description = '<p>bdfasjiasfelaskjfoaisdf@amskdfjaslidfjads.com</p><p><br></p><p><img src="https://viewsonic--fullsand--c.documentforce.com/servlet/rtaImage?refid=0EM78000000Gynr"></p><p><br></p><p>so</p><p>bdfasjiasfelaskjfoaisdf@amskdfjaslidfjads.com</p><p><br></p><p><img src="https://viewsonic--fullsand--c.documentforce.com/servlet/rtaImage?refid=0EM78000000Gynr"></p><p><br></p><p>so</p>';
        createFreshDeskTicket.updateTicket(description);
    }
    static testmethod void testCallout() {   
        test.startTest();     
        Account a = [Select id,FDACCOUNTID__c from account limit 1];
        a.FDACCOUNTID__c = '324234234'; 
        update a;
        FD_Groups__c fd = new FD_Groups__c();
        fd.groupName__c = 'somefakegroup';
        fd.isSandbox__c = true;
        insert fd;
        FD_Groups__c fdprod = new FD_Groups__c();
        fdprod.groupName__c = 'somefakegroup';
        fdprod.isSandbox__c = false;
        insert fdprod;
        String fdgroup = 'somefakegroup';
        Boolean addemails = true;
        String email = 'asfdsadfafdsasdfas@mail.com';
        String name = 'sfome name';
        String acctId = a.Id;
        String subject = 'subject';
        String description = 'description';
        
        createFreshDeskTicket.createTicket(email, name, acctId, subject, description,fdgroup,addemails);
        test.stopTest();
        
    }
    static testmethod void testCalloutErrorHandling() {
        test.startTest();
        Account a = [Select id,FDACCOUNTID__c from account limit 1];
        update a;
        String email = 'asfdsadfafdsasdfas@mail.com';
        String name = 'sfome name';
        String acctId = a.Id;
        String subject = 'subject';
        String description = 'description';        
        //createFreshDeskTicket.createTicket(email, name, acctId, subject, description);
        test.stopTest();
        
    }
    
    static testmethod void testerrorHelper() {
        String ername = 'createFreshDeskTicket ';
        String cmp = 'createFreshDeskTicket line 60';
        String userid = 'asdfsadfkj';
        String errmssg =  'error body';
        String recordId = '';
        String acctId = null;
        String calloutBody = 'error body';
        String recordname = 'error body';
        String objType = 'error body';
        createComponentErrorLog.createComponentErrorLog(ername, cmp, userid, errmssg, recordId, calloutBody, objType, acctId, recordname);
        
    }
}