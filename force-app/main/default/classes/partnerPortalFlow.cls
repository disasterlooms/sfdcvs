global without sharing class partnerPortalFlow {
    @AuraEnabled
    global static Boolean getDomain(String thedomain){
        Boolean isGeneric = false;
        List<GenericEmails__c>  gm = [Select id, name from GenericEmails__c where name =:thedomain];
        if(gm.size()>0){
            isGeneric = true;
        }
        system.debug('generic var '+isGeneric);
        return isGeneric;
    }
    @AuraEnabled
    global static Integer getCode(){
        Integer code;
        code =  Integer.valueof((Math.random()*100000));
        code = code+ Integer.valueof((Math.random()*100));
        code = code+ Integer.valueof((Math.random()*100));
        code = code+ Integer.valueof((Math.random()*10));
        return code;
    
    }
}