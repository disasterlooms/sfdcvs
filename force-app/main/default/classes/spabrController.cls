public class spabrController {
      @AuraEnabled 
    public static boolean getAccessDetails(){
        Id userProfileId = UserInfo.getProfileId();
        profile userProfile = [select ID,Name from profile where id = :userProfileId];
            if(userProfile.name == 'System Administrator IT' || userProfile.name == 'SPA Portal Admin')
            {
               return true;
            }
            return false;
        
    }

}