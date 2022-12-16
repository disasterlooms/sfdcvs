/**
* @Author  :  Jitendra Zaa
* @Desc  :  Utility class to run Enterprise Territory Management Assignment rules
* */
public class RunTerritoryRules implements Queueable, Database.AllowsCallouts  {
    public Set<String> accntIds = null;
    private String sessionId = null;    
    
    public RunTerritoryRules(Set<String> records) {
        this.accntIds = records;
    }
    public void execute(QueueableContext context) {
        TriggerContextUtility.setFirstRunFalse();
        system.debug('accts '+accntIds);
        Set<String> newIds = new Set<String>(accntIds);
        sessionId = UserInfo.getSessionID();     
        List<String> lstAccString = new List<String>();
        if(accntIds != null){
            for(String accId:accntIds){
                lstAccString.add(accountTag.replace('{ACCID}', accId)); 
            }
        } 
        requestTemplate = requestTemplate.replace('{ACCLISTS}', String.join(lstAccString, ' ')) ;
        requestTemplate = requestTemplate.replace('{SESSID}', sessionId) ;        
        HttpRequest request = new HttpRequest();
        request.setEndpoint(System.URL.getSalesforceBaseUrl().toExternalForm()+
                            '/services/Soap/u/41.0/'+UserInfo.getOrganizationId());
        request.setMethod('POST');
        request.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        request.setHeader('SOAPAction', '""');
        request.setBody(requestTemplate);
        queueOwnerAssign updateJob = new queueOwnerAssign(newIds);
        
        if(!Test.isRunningTest()){  String s = String.valueOf(new Http().send(request).getBodyDocument());System.debug(s);}      
        else{
            
        }
        
        //System.enqueueJob(updateJob);
        if(!Test.isRunningTest() && TriggerContextUtility.istriggerQueable()){
         System.enqueueJob(new accountContactOwner(accntIds));   
        }
        
        
    }
    String accountTag = '<urn:sObjects> '+
        '<urn1:type>Account</urn1:type>  '+
        '<urn1:Id>{ACCID}</urn1:Id>   '+
        '</urn:sObjects> ' ;    
    String requestTemplate = '<soapenv:Envelope '+
        'xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"'+
        ' xmlns:urn="urn:partner.soap.sforce.com"'+
        ' xmlns:urn1="urn:sobject.partner.soap.sforce.com">'+
        '<soapenv:Header> '+
        '<urn:AssignmentRuleHeader> '+ 
        '<urn:useDefaultRule>true</urn:useDefaultRule> '+
        '<urn:assignmentRuleId></urn:assignmentRuleId> '+
        '</urn:AssignmentRuleHeader>  '+
        '<urn:SessionHeader> '+
        '<urn:sessionId>{SESSID}</urn:sessionId> '+
        '</urn:SessionHeader> '+
        '</soapenv:Header> '+
        '<soapenv:Body> '+
        '<urn:update> '+
        ' {ACCLISTS}'+ 
        '</urn:update> '+
        '</soapenv:Body> '+
        '</soapenv:Envelope>';
    
    
    
}