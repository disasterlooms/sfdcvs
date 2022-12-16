public class portalContactUpdate implements Queueable {

    private List<User> users;
    
    public portalContactUpdate(List<User> records) {
        this.users = records;
    }
    
    public void execute(QueueableContext context) {
        Set<Id> relatedCons = new Set<Id>();
        
        Map<String,User> us = new Map<String,User>();
        for(User u : [Select id, ContactId,email,phone,city,state,country from user where id in : users]){
            us.put(u.ContactId, u);
            relatedCons.add(u.ContactId);
        }
        
        List<Contact> consToUpdate = [Select id, email, phone, mailingcity,mailingstate,mailingcountry from contact where id in: relatedCons];
        
        for(Contact c : consToUpdate){
            if(us.ContainsKey(c.Id)){
                User u = us.get(c.id);
                c.email = u.email;
            }           
            
        }
        
        try{
            update consToUpdate;
        }catch(Exception e){
            String t = 'Error updating the contact after User updated email ';
            AdminErrorMessage.SendError(e, t);
        }       
    }
}