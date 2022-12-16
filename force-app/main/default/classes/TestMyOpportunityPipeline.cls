@isTest
private class TestMyOpportunityPipeline {
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void getPicklists()  
    {
        //  Methods industries and status  is metadata, don't need records,
        //   just need to run the method
        //   product types is querying the product pillar object
        //   which a record is created in build test data testsetup
        test.startTest();
        MyOpportunityPipeline.getStatus();
        MyOpportunityPipeline.getIndustries();
        MyOpportunityPipeline.getUser();
        MyOpportunityPipeline.getProdTypes();
        test.stopTest();
    }
    
    static testmethod void getOpps()
        
    {		        
        List<Opportunity> opps = new List<Opportunity> ();
        List<OpportunityLineItem> lines = new List<OpportunityLineItem> ();
        String product  = '';
        String reseller = '';
        String enduser  = '';
        String industry = ''; 
        String prodtype = '';
        String srep = '';
        
        //need to to run getOpps method with prod,reseller,enduser as null and with 
        //value to get if else statements 
        test.startTest();       
        
        MyOpportunityPipeline.getOpps(product,reseller,enduser,industry,prodtype,srep);
        product  = 'va';
        reseller = 'cdw';
        enduser  = 'edu';
        industry = 'edu';
        prodtype = '';
        
        opps =  MyOpportunityPipeline.getOpps(product,reseller,enduser,industry,prodtype,srep);
        
        system.debug('see opps '+opps);
        
        opps = [Select Id, Name from Opportunity limit 4];
        lines = [select Id,Name from OpportunityLineItem]; 
        MyOpportunityPipeline.UpdateOpps(opps,lines);
        
        for(OpportunityLineItem l : lines){
            l.Status__c = 'fail';
        }
        MyOpportunityPipeline.UpdateOpps(opps,lines);
        //method UpdateOpps
        //method new product  need to use all variables and need records for the line item to be added
        //for new product method can do inactive and active price book entry
        //method delete product                
        
        test.stopTest();
    }
    static testmethod void newprod()
    {	
        List<Opportunity> opp = [select Id,pricebook2id from Opportunity limit 1 ];
        List<PricebookEntry> line = [select Id from pricebookentry where isactive = true
                                     and pricebook2id =:  opp[0].pricebook2id];
        
        String oppid = opp[0].Id;
        String prodid = line[0].Id;
        Decimal quant = 3;
        Decimal spaprice = 100;
        String ship = '2017-10-10';
        String status = 'Interest';
        String compete = '';
        
        
        
        test.startTest(); 
        MyOpportunityPipeline.newprod(oppid,prodid,quant,spaprice,ship,status,compete);
        test.stopTest(); 
        
        
        
    }
    static testmethod void delProd()
    {	
        String Product = ''; 
        List<Opportunity>  opps = [select Id from Opportunity limit 3 ];
        List<OpportunityLineItem> lines = [select Id from OpportunityLineItem];      
        String prodid = lines[0].Id;
        
        test.startTest(); 
        MyOpportunityPipeline.delProd(prodid,opps,lines,product);
        test.stopTest(); 
        
        
        
    }
    static testmethod void  getSchedule()
    {	
        String product  = '';
        String reseller = '';
        String enduser  = '';
        String industry = ''; 
        String prodtype = '';
        String srep = '';       
        
            
        test.startTest();
        
        Opportunity opp = [Select Id,pricebook2id from Opportunity limit 1];  
        PriceBookEntry pbe = [Select id,product2id from pricebookentry 
                              where isactive = true 
                              and pricebook2id =: opp.pricebook2id limit 1];
        
        Product2 p = [Select id, CanUseQuantitySchedule  from Product2 where Id =: pbe.Product2id];
        p.CanUseQuantitySchedule  = true;
        update p;
        
        Opportunitylineitem l = new Opportunitylineitem(OpportunityId = opp.id,
                                                        quantity=20,
                                                        unitprice=300,
                                                        pricebookentryid= pbe.id);
        
        insert l;
        
        List<OpportunityLineItem> opps = new List<OpportunityLineItem>();
        
        Boolean myopps = false;
        Boolean likely = false;
        Boolean committed = false;  
        
        opps =  MyOpportunityPipeline.getSchedule(product,reseller,enduser,industry,
                                                  prodtype,srep,myopps,likely,committed);
        
         opps.add(l);
        
        List<OpportunityLineItemSchedule> lines = new List<OpportunityLineItemSchedule>();
        
        OpportunityLineItemSchedule sch = new OpportunityLineItemSchedule(opportunitylineitemid= l.Id,
                                                                          Quantity = 0,
                                                                          ScheduleDate = date.today(),
                                                                          Type = 'Quantity');
        insert sch;
        lines.add(sch);
        MyOpportunityPipeline.updatesch(opps,lines);
        
        for(OpportunityLineItem ol : opps){
            ol.Quantity = null;
        }
        for(OpportunityLineItemSchedule ols : lines){
            ols.Quantity = null;
        }
        MyOpportunityPipeline.updatesch(opps,lines);
        test.stopTest(); 
        
    }
}