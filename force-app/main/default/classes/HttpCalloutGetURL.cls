public class HttpCalloutGetURL {
	// Pass in the endpoint to be used using the string url

	@AuraEnabled
	public static String getCalloutResponseContents(String url) {
        url = url+'&s=AwQZsQ7bc28YUVZSDzKbvkejm3AnjQQv';
        // Instantiate a new http object
		Http h = new Http();
        system.debug(url);
		// Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
		HttpRequest req = new HttpRequest();
		req.setEndpoint(url);
		req.setMethod('GET');
        String result = 'Test is running or no data returned';
		// Send the request, and return a response
        if(!Test.isRunningTest()){HttpResponse res = h.send(req);System.debug('response:--> ' + res.getBody());result = res.getBody();}
		      
        
        return result;
	}
      
     //START: Added by Shweta: SR:19408
     @AuraEnabled
      public static Quote getSpa(String spaNo){
            System.debug('Entered here ');
            Quote q = [select id from Quote where Name=:spaNo];
            System.debug('Fetch value '+q);
            return q; 
      }
     //END: Added by Shweta: SR:19408
}