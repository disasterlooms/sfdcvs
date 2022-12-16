public with sharing class SandboxConUserLink{
    public static void updatecons(List<Contact> records){
    	


    	 Set<String> emails = new Set<String>();
         for (Contact record : records) emails.add(record.Email);

         Map<String, User> managers = new Map<String, User>();

         for (User manager : [
         	SELECT Id,Name,Email FROM User
            WHERE Email IN :emails
       		])managers.put(manager.Email , manager);

          

          List<Contact> consToUpdate = new List<Contact>();
           for (Contact  con : records){
           	 	if (managers.containsKey(con.Email)){
           	 		if(con.GetUserId__c == true){
                //con.UserID__c = managers.get(con.Email).Id;
           		con.GetUserId__c	= false;
           		con.UserID__c = managers.get(con.Email).Id;
           		//ContactUser.FindUser(trigger.new);
            }else{
            	con.GetUserId__c	= false;
            }
            con.GetUserId__c	= false;
           	 	}
             
           		con.GetUserId__c	= false;	
           			
           		
           }

          
  	}
  }