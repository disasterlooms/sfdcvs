global without sharing class QuoteResubmission {
    @InvocableMethod
    public static void getRates(List<String> quoteid) {
        system.debug(quoteid);
        
        String recid = '';
        String resub = '';
        Integer checklen = null;
        
        
        for(String q : quoteid){
            recid = q.left(18);
            system.debug('recid ' +recid);
            checklen = q.length();            
            resub = q.mid(18,checklen-18);
            system.debug('resub' +resub);            
        }      
        
        Quote q = [Select id, resubmission_notes__c from quote where id =: recid];
        
        q.resubmission_notes__c = resub;
        update q;       
        
    }
}