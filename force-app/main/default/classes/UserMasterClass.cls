global without sharing class UserMasterClass {
    Map<Id, User> oldUsers;
    Map<Id, User> newUsers;
    
    public UserMasterClass(
        Map<Id, User> oldTriggerUsers, 
        Map<Id, User> newTriggerUsers) {
            
            oldUsers = oldTriggerUsers;
            newUsers = newTriggerUsers;
        }
    
    global static void CreateContact(List<User> users) {
        
        Set<Id> resultIds = (new Map<Id,User>(users)).keySet();
        UserMasterClass.UserConInfo(resultIds);
    }
    global static void newParnterUserCreated(List<User> users) {
        
        List<User> userVSParnters= [Select id,contactId,isactive,email,newPartnerWelcomeEmail__c
                                    from user where newPartnerWelcomeEmail__c = true and id in :users];
        //if you need to ensure that user is part of specific community there 
        //are two options, one is to set a field in the partner application/form
        //that is specific to the community, which is what is done in this case or 
        //add the community for example 
        //Select id, isactive,email,newPartnerWelcomeEmail__c from user where id in 
        //from user where id in (select memberid from networkmember where networkid = 'communitynetworkid')

        
 		system.debug('new partner class running for partner users welcome email');            
            for(User u : userVSParnters){    
                 
                  System.resetPasswordWithEmailTemplate(u.Id, true, 'pp_Welcome_Email');
                  Task nT = new Task();
                  nT.Subject = 'Welcome Email Partner Program Sent';
                  nT.WhoId = u.ContactId;
                  nT.Status = 'Completed';
                  nt.ActivityDate = date.today();
                  nt.Type = 'Email';
                  insert nT;


            }
      
       
    }
    
    global void portalUserUpdate() {
        
        List<User> users = new  List<User>();
        
        for (User u : newUsers.values()) {
            User oldUser  = oldUsers.get(u.Id);
            if(u.usertype != 'Standard' && (u.email != oldUser.email || 
                                            u.phone != oldUser.phone ||
                                            u.city != oldUser.city ||
                                            u.State != oldUser.State ||
                                            u.Country != oldUser.Country
                                           )){
                                               //update the contat with a future call
                                               users.add(u);
                                           }
            
        }
        portalContactUpdate updateJob = new portalContactUpdate(users);
        System.enqueueJob(updateJob);
    }
    
    @future
    global static void UserConInfo(Set<Id> records) {
        system.debug(FutureContext.futureHasRun());
        if (!FutureContext.futureHasRun() || Test.isRunningTest()) {    
            FutureContext.setFutureRan();  
            
            List<User> users = [Select Id,Contact_ID__c,Contact_Name__c,usertype,AccountId__c,Email,Sales_Category__c,FirstName,
                                LastName,Phone,Street,City,State,PostalCode,Country,Title,Accounting_Category__c
                                from User where Id In: records ];
            
            List<User> usersToUpdate = new List<User>();
            
            List <Account> vs = [Select Id from account where name = 'ViewSonic Corporation' limit 1];
            
            for(User u : users){
                
                if(u.Sales_Category__c != 'Distributor Partner' &&
                   u.UserType =='Standard' && vs.size()>0){
                    
                    Contact con = new Contact(
                        FirstName= u.FirstName,
                        LastName=u.LastName, 
                        email= u.Email, 
                        phone=u.Phone,
                        MailingStreet = u.Street,
                        MailingCity = u.City,
                        MailingState = u.State,
                        MailingPostalCode = u.PostalCode,
                        MailingCountry = u.Country,
                        OwnerId = u.Id,
                        Title = u.Title,
                        Business__c = u.Accounting_Category__c,
                        AccountId = vs[0].Id,
                        UserID__c = u.Id
                    );
                    
                    if(!Test.isRunningTest()){
                        insert con;   
                    }
                    
                    
                    u.Contact_ID__c = con.Id;
                    u.Contact_Name__c = u.FirstName+' '+u.LastName;
                    u.AccountId__c = vs[0].Id;
                    usersToUpdate.add(u);
                    
                    
                }		
            }
            
            update usersToUpdate;
            
             
        }
    }
}