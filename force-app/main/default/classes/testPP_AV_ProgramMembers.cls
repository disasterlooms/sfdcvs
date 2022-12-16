@isTest
private class testPP_AV_ProgramMembers{
     public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    @testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
    static testmethod void TestPP_AV_ChannelPrograms() {
        
        test.startTest();
        Account avAcct = new Account(Name='Some AV Company  LLC',Duplicate_Rule_Suppres__c  = true, 
        BillingCountryCode ='US', BillingStreet='12234343 masfasain',
        website = 'Zpdadfas345gwertwrtfesst.com',BillingCity='citysome',
        spiff_type__c = 'Sales Rep',
        AV_Solutions_Partner__c = false,
        billingPostalCode='7238389', BillingState = 'Arizona',
        Type='AV',Industry= 'Business');
        Database.DMLOptions dml = new Database.DMLOptions(); 
            dml.DuplicateRuleHeader.allowSave = true;
        database.insert(avAcct,dml);

        List<ChannelProgram> programs = new List<ChannelProgram>();
        
        ChannelProgram cp = new ChannelProgram();
        cp.Name = 'Test AV Spiff';
        cp.Automate_Members_via_Code__c = true;
        cp.Spiff_Type_Specific__c = 'Sales Rep';
        cp.Country__c = 'United States';
        cp.Category = 'AV';
        cp.Sub_Category__c = 'Spiff Type'; 
        cp.VS_Region__c = 'VSA';
        cp.VS_SubRegion__c = 'VSA US';     
        programs.add(cp);
        
        ChannelProgram cps = new ChannelProgram();
        cps.Name = 'Test AV Cert';
        cps.Automate_Members_via_Code__c = true;
        cps.AV_Certified_Only_Members__c = false;
        cps.Country__c = 'United States';
        cps.Category = 'AV';
        cps.VS_Region__c = 'VSA';
        cps.VS_SubRegion__c = 'VSA US';    
        cps.Sub_Category__c = 'Certification';       
        programs.add(cps);

        insert programs;
        
         // Schedule the test job
        String jobId = System.schedule('pp_AV_ProgramMembership',
                                       CRON_EXP, 
                                       new pp_AV_ProgramMembership());
        Test.stopTest();
        
        
        
    }
}