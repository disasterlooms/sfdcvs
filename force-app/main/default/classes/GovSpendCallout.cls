public class GovSpendCallout {
	
    private String apiKey;    
    
    public GovSpendCallout(String apiKey){
        this.apiKey = apiKey;
    }
    
    public HttpResponse runSavedSearch(String searchId, Integer page){      
        String url='https://app.govspend.com/runSavedSearch';
        String requestBody = '{"id": "'+searchId+'","page": '+page+',"include": [],"sortDir": "asc","sortField": ""}';
		Http http = new Http();
		HttpRequest request = new HttpRequest();
        request.setBody(requestBody);
		request.setEndpoint(url);
		request.setMethod('POST');
		request.setHeader('content-type', 'application/json');
		request.setHeader('X-API-KEY', this.apiKey);
		return http.send(request);        
        
    }
    
    public HttpResponse exportCreditStats(String searchId){
        
        String url='https://app.govspend.com/exportCreditStats';
		String queryParam = searchId!=null ? '?searchId='+searchId : '';       
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndpoint(url+queryParam);
		request.setMethod('GET');
		request.setHeader('content-type', 'application/json');
		request.setHeader('X-API-KEY', this.apiKey);
		return http.send(request);        
    
    }
                       
                           
}