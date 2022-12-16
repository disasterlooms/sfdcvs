@IsTest
public class TestSpaStage {
    Static testmethod void TestSpaStage() {
    
        PriceBook2 pb = new Pricebook2(Name='VSA Distributor Price List',IsActive=true);
        insert pb;

        PriceBook2 pb2 = new Pricebook2(Name='VSA Canadian Price List',IsActive=true);
        insert pb2;

        PriceBook2 pb3 = new Pricebook2(Name='VSA CDW Price List',IsActive=true);
        insert pb3;

            Opportunity o = new Opportunity();
            o.Name = 'Apex Test';
            o.Type = 'Project' ;
            o.CloseDate = Date.Today() ;
            o.StageName = 'Contract';
            o.Spa_Approval_Date__c = Date.Today() ;
            o.Distributor_Account__c = True;
            o.Auto_Update_Opp_Name__c = false;
             insert o;
             
            
             }
       
 }