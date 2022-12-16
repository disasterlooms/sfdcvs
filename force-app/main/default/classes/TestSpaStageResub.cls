@IsTest
public class TestSpaStageResub {
    Static testmethod void TestSpaStageResub() {
    
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
            o.Distributor_Account__c = True;
            o.Auto_Update_Opp_Name__c = false;
             insert o;
            
            Opportunity op = new Opportunity();
            op.Name = 'Apex Test';
            op.Type = 'Project' ;
            op.CloseDate = Date.Today() ;
            op.StageName = 'Contract';
            //op.Spa_Resubmission_Note__c='Test';
            o.Auto_Update_Opp_Name__c = false;
             insert op;
             
             Opportunity op1 = new Opportunity();
            op1.Name = 'Apex Test';
            op1.Type = 'Project' ;
            op1.CloseDate = Date.Today() ;
            op1.StageName = 'Contract';
            o.Auto_Update_Opp_Name__c = false;
             insert op1;
        }
       
 }