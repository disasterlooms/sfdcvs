public without sharing class recordLockedFlowCheck {    
    @auraEnabled
    public static Boolean checkLocked(String recordId){
        Boolean isLocked = Approval.isLocked(recordId);
         return isLocked;
        
    }
}