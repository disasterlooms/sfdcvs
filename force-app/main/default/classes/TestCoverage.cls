@isTest 
public class TestCoverage{
    static testmethod void myCoverageTest() {  
        
        //Create Contact
       
        BuildTestData.AddRecords();
        Account a = [Select Id from Account where name ='ZZpbest' limit 1];

        Contact Con = new Contact(
            lastname = 'test',
            email = 'email@test.com',
            MailingStreet = '123 Main Street',
            MailingCity = 'Test City',
            MailingState = 'CA',
            MailingPostalCode = '12345',
            AccountId =a.id,
            MailingCountry = 'Test Country');
        Insert Con;
        
        //Create Eval_Request
        Eval_Request__c ER = new Eval_Request__c(
            eval_type__c = 'Trade Show Loaner', 
            Evaluation_Owner__c = Con.Id,
            Expected_Receive_Date__c = Date.today(), 
            Billing_Contact_Name__c = Con.id,
            Shipping_contact_Name__c = Con.id,
            Ship_Method__c = 'Delivery',
            Product_Name__c = '01tA0000003J4iH',
            Quantity__c = 1.0);
            
        Insert ER;
        
        // Create Eval_Unit_Dtails       
        Eval_Unit_Details__c EUD1 = new Eval_Unit_Details__c(
        Eval_Request__c = ER.id,
        //Product_SKU__c = SKU,
        Name = '123testnumber',
        RMA__c = '123testnumber',
        Courier_Info__c = 'FedEx-Parcel-Standard Overnight',
        Ship_Date__c = date.today(),
        Tracking_Number__c = '123trackingnumber');
        insert EUD1;
        
        Eval_Unit_Details__c EUD2 = new Eval_Unit_Details__c(
        Eval_Request__c = ER.id,
        //Product_SKU__c = SKU,
        Name = '123testnumber',
        RMA__c = '123testnumber',
        Courier_Info__c = 'FedEx-Parcel-Standard Overnight',
        Ship_Date__c = date.today(),
        Tracking_Number__c = '123trackingnumber');
        insert EUD2;  
        
        Eval_Unit_Details__c EUD3 = new Eval_Unit_Details__c(
        Eval_Request__c = ER.id,
        //Product_SKU__c = SKU,
        Name = '123testnumber',
        RMA__c = '123testnumber',
        Courier_Info__c = 'FedEx-Parcel-Standard Overnight',
        Ship_Date__c = date.today(),
        Tracking_Number__c = '123trackingnumber');
        insert EUD3;
    }
}