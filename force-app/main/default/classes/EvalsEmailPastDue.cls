global class EvalsEmailPastDue implements Schedulable {
	global void execute(SchedulableContext sc) {
		
		List<Contact> cons = [Select Id,LastName,FirstName,Email,
							 UserID__r.Email from Contact];
		system.debug('results num: '+cons.size());
		if(cons.size()>0){

			for(Contact c : cons){

				system.debug('conid: '+c.id);

		    Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
            String[] cc = new String[] {Label.AdminEmail};
            mail.setTargetObjectId(c.Id);
            mail.setWhatId(c.Id);
            mail.setTemplateId('00X12000001ikd0');
            mail.setCcAddresses(cc); 
            mail.setSaveAsActivity(false);           
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

        }


		}
		
	}
}