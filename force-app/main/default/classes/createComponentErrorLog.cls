public without sharing class createComponentErrorLog {
    @future
    public static void createComponentErrorLog(String name, String cmp,String userid,String errmssg,
    String recordId,String calloutBody,String objType,String acctId,String recordname) {
        
        Apex_Error_Message__c am = new Apex_Error_Message__c();
            am.Name = name; 
            am.recordId__c = recordId;
            am.Callout_Body__c = calloutBody;
            am.RecordName__c = recordname;
            am.Account__c = acctId;
            am.Error_Message__c = errmssg;
            am.Apex_Class__c = cmp;
            am.UserId__c =userid;
            am.ObjectType__c  = objType;

            insert am;
    }
}