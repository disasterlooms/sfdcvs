global class posPYschFuture
{
    @future(callout=true)
    public static void updatePYRevenue() {
        
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
        
        

        String pyr = string.valueOf(Date.today().year()-1);
        Wave.ProjectionNode[] projspy = new Wave.ProjectionNode[] {Wave.QueryBuilder.get('ShipToAccount'),Wave.QueryBuilder.get('REVENUE').sum().alias('RevenuePY')};
        List<List<String>> orderspy = new List<List<String>>{new List<String>{'RevenuePY', 'desc'}};        
        String querypy = Wave.QueryBuilder.load('0Fb1H000000MMWxSAO', cv).filter('ViewSonicEndUser == \"true\"  && SaleDateYear == \"'+pyr+'\"').group(new String[]{'ShipToAccount'}).foreach(projspy).order(orderspy).cap(2000).build('q');     
        ConnectApi.LiteralJson resultpy =  ConnectApi.Wave.executeQuery(querypy);
        String responsepy = resultpy.json;
        system.debug(responsepy);
        JSON2Apex.parse(responsepy);  
        
      

        
    }
}