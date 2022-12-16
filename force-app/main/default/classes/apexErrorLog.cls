public class apexErrorLog {
    Public static void logError(String recId, String objType,String apexClass,String errMessage) {        
         // as of 9/24/2020 the test class for this is testmasterquote trigger
         // there is a forced error in when runnig test in line 76 or OpportunityTeamAdd when this class is ran in line 87 
         // 
         // it may be a good idea for this to run in the build test data class but since it is not needed now, will use this method **Orbison**
         // 
         // There is a UI Interaction object that is used by both Apex and lightning components. will eventually merge these 2 objects
         // 
        Apex_Error_Message__c msg = new Apex_Error_Message__c ();
        msg.recordId__c = recId;
        msg.ObjectType__c  = objType;
        msg.Apex_Class__c = apexClass;
        msg.UserId__c = userinfo.getUserId();
        msg.Error_Message__c = errMessage;
        try{
            insert msg;
        }catch(Exception e){
            String t = 'Error inserting the new Log for Apex Errors see message ';
            AdminErrorMessage.SendError(e, t);
        }
        
    }
}