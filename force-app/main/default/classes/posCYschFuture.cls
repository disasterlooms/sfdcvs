global class posCYschFuture
{
    @future(callout=true)
    public static void updateCYRevenue() {
        
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setHeader('content-type', 'application/json.');
        req.setMethod('GET');
        req.setEndpoint( URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v48.0/wave/datasets/0Fb1H000000MMWxSAO');
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        
        Boolean runningInASandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        
        String cv = '';
        
        //The version id for the dataset is alwys changing and need to do callout to get the EA Dataset version id
        //since callouts are not allowed via test, I am hard coding the version id. 
        //if we need to update this and test classes then it may be better to create a metadata ojbect but even if we
        //do that, we will still have to put the data in the metadata object after we use rest api to get version id. 
        //
        //thanks salesforce.  Jason Orbsion 10.15.2020
        //
        //
        if(runningInASandbox && Test.isRunningTest() ){
            cv = '0Fc5c000002SDkRCAW';  
        }else{
            cv = '0Fc5c000002SSR0CAO';
        }
        
        Http http = new Http();
        if(!Test.isRunningTest()){
            HTTPResponse resp = http.send(req);JSONParser parser = JSON.createParser(resp.getBody());
            while (parser.nextToken() != null) {if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'currentVersionId')) {
                parser.nextToken();cv = parser.getText();
            }
                                               }
            system.debug(cv);
        }      
        
        String cyr = string.valueOf(Date.today().year()); 
        Wave.ProjectionNode[] projs = new Wave.ProjectionNode[] {Wave.QueryBuilder.get('ShipToAccount'),Wave.QueryBuilder.get('REVENUE').sum().alias('RevenueCY')};
            List<List<String>> orders = new List<List<String>>{new List<String>{'RevenueCY', 'desc'}};        
                String query = Wave.QueryBuilder.load('0Fb1H000000MMWxSAO', cv).filter('ViewSonicEndUser == \"true\"  && SaleDateYear == \"'+cyr+'\"').group(new String[]{'ShipToAccount'}).foreach(projs).order(orders).cap(2000).build('q');     
        ConnectApi.LiteralJson result =  ConnectApi.Wave.executeQuery(query);
        String response = result.json;
        system.debug(response);
        JSON2Apex.parse(response); 
        /*
        * Comment. jorbison 8.25.2021 commenting out this code because the id will always match with this query below. 
        * there may be a need to map the new accounts with POS revenue, the code below will not do this so need to investigate
        * if there is another process that links the data
        * 
        List<Account> acc = [Select id, POS_Revenue__c ,(select id from POS_Revenue__r) from account where id in (select Account_Name__c  from POS_Revenue__c)];
        for(Account a : acc){
        for(POS_Revenue__c r :a.POS_Revenue__r){
        a.POS_Revenue__c = r.Id;
        }
        }
        update acc;
        */
        
        List<Account> acc = [Select id, POS_Revenue__c ,(select id from POS_Revenue__r) from account where id in (select Account_Name__c  from POS_Revenue__c)];
        Map<Id,Account> upAcct = new Map<Id,Account>();
        
        for(Account a : acc){
            for(POS_Revenue__c r :a.POS_Revenue__r){
                if( a.POS_Revenue__c != r.Id){
                    Account neAcct = new Account();           
                    neAcct.POS_Revenue__c = r.Id;
                    neAcct.Id = a.Id;
                    upAcct.put(neAcct.Id,neAcct);
                }
            }
        }
        system.debug(upAcct.size()+' size of accounts to be updated');
        List<Account> upAcctL = new List<Account>();
        for(Account a : upAcct.values()){
            upAcctL.add(a);
        }
        
        update upAcctL;
        
    }
}