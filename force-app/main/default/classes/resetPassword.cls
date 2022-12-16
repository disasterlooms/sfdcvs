global without sharing class resetPassword {
    @AuraEnabled
    global static Boolean resetP(String emailUser){
        emailUser= emailUser.trim();
        Boolean userExists = false;
        try{
            User u = [Select id from user where email =: emailUser and IsActive = true limit 1];
            System.resetPassword(u.id,true); 
            userExists = true;
        }catch(Exception e){
           userExists = false;String t = 'Reset Password Error on Portal '+emailUser+' : ';  AdminErrorMessage.SendError(e, t);
          
        }     
        return userExists;
    }
}