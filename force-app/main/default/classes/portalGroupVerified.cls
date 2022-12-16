public class portalGroupVerified implements Queueable {  
  
    Set<Id> records = new Set<Id>();
  
    public portalGroupVerified(Set<Id> records) {  
  
        this.records = records;  
    }    
    public void execute(QueueableContext qc) { 
        
        List<User> us = [Select id, profileId from User where ContactId in : records];
        Group g = [Select id from group where name = 'Portal Resellers Verified' limit 1];
        
        List<GroupMember> members = new List<GroupMember>();
        for(User u : us){
		GroupMember gm = new GroupMember();
            gm.GroupId = g.Id;
            gm.UserOrGroupId = u.Id;
            
            members.add(gm);
        }
        insert members;  
    }  
  
}