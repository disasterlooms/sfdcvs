global with sharing class userLicenseGet {
    global static void getUsers(){
        
        List<User_Licenses__c> licToDelete = [select id from User_Licenses__c];
        delete licToDelete;
        List<User_Licenses__c> lic = new List< User_Licenses__c >();
        
        
        List<User> getUsers = [select id, name, firstname,lastname,email,username,profile.UserLicense.Name,Country,manager.Name
                               ,CreatedDate,Department, Region__c  from user where
                profile.UserLicense.Name in ('Salesforce Platform','Salesforce','Partner Community','Partner Community Login') and isActive = true];
        
        List<PermissionSetLicenseAssign> getBIUsers = [SELECT AssigneeId,Id, PermissionSetLicense.MasterLabel,CreatedDate,
                             Assignee.Department ,Assignee.Email,Assignee.profile.UserLicense.Name,Assignee.Manager.Name,
                                                       Assignee.FirstName, Assignee.LastName,Assignee.Country , Assignee.Region__c,Assignee.Username
                                                       FROM PermissionSetLicenseAssign 
                             where PermissionSetLicense.MasterLabel = 'Analytics Platform' and assignee.isactive = true];
        
        for(User u : getUsers){
            DateTime dT = u.CreatedDate;
            User_Licenses__c ul = new User_Licenses__c();
            ul.CreatedDate__c = date.newinstance(dT.year(), dT.month(), dT.day());
            ul.Department__c  = u.Department;
            ul.Email__c  = u.Email;
            ul.License_Type__c  = u.profile.UserLicense.Name;
            ul.Manager__c  = u.Manager.Name;
            ul.Name__c = u.FirstName+' '+u.LastName;
            ul.UserName__c = u.username;
            ul.Country__c = u.Country;
            ul.Region__c = u.Region__c;
            lic.add(ul);
        }
        
        
        for(PermissionSetLicenseAssign u : getBIUsers){
            User_Licenses__c ul = new User_Licenses__c(); 
            DateTime dT = u.CreatedDate;
            ul.CreatedDate__c = date.newinstance(dT.year(), dT.month(), dT.day());
            ul.Department__c  = u.Assignee.Department;
            ul.Email__c  = u.Assignee.Email;
            ul.License_Type__c  = 'Tableau CRM (Einstein Analytics)';
            ul.Manager__c  = u.Assignee.Manager.Name;
            ul.Name__c = u.Assignee.FirstName+' '+u.Assignee.LastName;
            ul.UserName__c = u.Assignee.username;
            ul.Country__c = u.Assignee.Country;
            ul.Region__c = u.Assignee.Region__c;
            
            
            
            lic.add(ul);
            
        }
        
        insert lic;
    }
}