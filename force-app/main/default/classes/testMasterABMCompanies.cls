@IsTest
public class testMasterABMCompanies  {
    Static testmethod void testMasterabmTrigger() {
        masterABMCompaniesClass.acctDomain(); 
        /*
        Account a = [Select id, domain__c from account where domain__c != null limit 1];
        
        sixsense__X6sense_New_Company__c comp = new sixsense__X6sense_New_Company__c();
        comp.name = 'test';
        comp.sixsense__CompanyId__c  = '456';
        comp.sixsense__Website__c = a.domain__c;
        insert comp;
        
        
        
      
        update comp;
		 */ 
        
    }
}