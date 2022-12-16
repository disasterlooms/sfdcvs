global class pp_AV_ProgramMembership implements Schedulable {
    global void execute(SchedulableContext ctx) {
        List<ChannelProgramMember> membersToAdd = new List<ChannelProgramMember> ();
        
        List<ChannelProgramMember> membersList = new List<ChannelProgramMember> ();
        
        
        List<Account> accts = [Select id,BillingCountry,spiff_type__c, AV_Solutions_Partner__c 
                               from account where type = 'AV' and BillingCountry != null];
        Map<String, ChannelProgram> spiff = new Map<String, ChannelProgram>();
        Map<String, ChannelProgram> cert = new Map<String, ChannelProgram>();
        List<ChannelProgram> cProgram = new List<ChannelProgram>();
        for(ChannelProgram cp : [ Select id, Sub_Category__c,Country__c, AV_Certified_Only_Members__c, Spiff_Type_Specific__c 
                                 from ChannelProgram where Automate_Members_via_Code__c = true]){
                                     cProgram.add(cp);
                                     if(cp.Sub_Category__c == 'Certification'){
                                         //String cString = string.valueOf(cp.AV_Certified_Only_Members__c);
                                         
                                         cert.put(cp.Country__c+string.valueOf(cp.AV_Certified_Only_Members__c),cp);
                                     }
                                     if(cp.Sub_Category__c == 'Spiff Type'){
                                         spiff.put(cp.Country__c+cp.Spiff_Type_Specific__c,cp);
                                     }
                                     
                                 }  
        system.debug(cert);
        system.debug('numb of accts '+ accts);
        
        for(Account a : accts){
            if(spiff.containsKey(a.BillingCountry+a.Spiff_Type__c)){
                ChannelProgram spiffType = spiff.get(a.BillingCountry+a.Spiff_Type__c);
                ChannelProgramMember m = new ChannelProgramMember();
                m.PartnerId = a.Id;
                m.ProgramId = spiffType.Id;
                membersList.add(m);
            }
            if(cert.containsKey(a.BillingCountry+string.valueOf(a.AV_Solutions_Partner__c))){
                ChannelProgram certType = cert.get(a.BillingCountry+string.valueOf(a.AV_Solutions_Partner__c));
                ChannelProgramMember mc = new ChannelProgramMember();
                mc.PartnerId = a.Id;
                mc.ProgramId = certType.Id;
                membersList.add(mc);
            }
        }
        Map<String, ChannelProgramMember> cpm = new Map<String, ChannelProgramMember>();
        for(ChannelProgramMember c : [Select id , partnerId , programid from channelprogrammember where programId in: cProgram]){
            cpm.put(string.valueOf(c.programId)+string.valueOf(c.PartnerId),c);
        }
        for(ChannelProgramMember mem : membersList){
            
            if(!cpm.containsKey(string.valueOf(mem.ProgramId)+string.valueOf(mem.PartnerId))){
                membersToAdd.add(mem);
            }
            
        }
        
        system.debug('member list then member list size then member to add and the member to add size');
        system.debug(membersList);
        system.debug(membersList.size());
        
        
        system.debug(membersToAdd);
        system.debug(membersToAdd.size());
        database.insert(membersToAdd,false);
        
    }
}