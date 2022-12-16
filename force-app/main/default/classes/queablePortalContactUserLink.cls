global class queablePortalContactUserLink implements Schedulable {
    global void execute(SchedulableContext ctx) {
       List<Contact> cons = [Select id,PortalUserId__c, (Select id, contactid from users) 
                             from contact where id in (Select contactid from user) and PortalUserId__c = null];
        for(Contact c : cons){
            c.PortalUserId__c = c.Users[0].Id;
        } 
        update cons;
    }
}