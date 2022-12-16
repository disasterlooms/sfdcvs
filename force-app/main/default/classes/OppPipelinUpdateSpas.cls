public without sharing class OppPipelinUpdateSpas {
    @AuraEnabled
    public static List<Quote> updateopps(List<Quote> newspas,List<Quote> oldspas)
    {
        Map<Id,Quote> oldq = new Map<Id,Quote>(oldspas);
        List<Quote> qToUPdate = new List<Quote>();
        
        for(Quote q : newspas){
            Quote old = oldq.get(q.Id);
            if(old.Resubmission_Notes__c != q.Resubmission_Notes__c){
              qToUPdate.add(q);  
            }
        }
        
        system.debug(qToUPdate);
        try{
            update qToUPdate;
        }catch(Exception e){ throw new AuraHandledException('There were some errors: '+e.getMessage());}
        return newspas;
    }

}