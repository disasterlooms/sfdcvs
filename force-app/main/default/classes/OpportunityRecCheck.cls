public class OpportunityRecCheck {
    Public static Boolean removeOpps(List<Opportunity> opps) {
        //check if there is one record that is being cloned in the trigger.new list
        
        Boolean cloning = false;
        
        List<Opportunity> records = new List<Opportunity>();        
        
        //list of records that are being cloned. This sends record to class to clone record
        List<Opportunity> clones = new List<Opportunity>();   
        
        for(Opportunity o : opps){
            if(o.cloning__c == false){
                records.add(o);
            }else{
                clones.add(o);
            }
        }
        
        if(records.size() > 0){
            cloning = false;
        }else{
            cloning = true;
        }
        
        if(clones.size() >0){
            
        }
        
        system.debug(' is this cloning? ' +cloning);
        return cloning;
        
    }
    Public static Boolean oppTrigUpdate(Map<Id, Opportunity> oldOpps, Map<Id, Opportunity> newOpps) {
        
        //checks if record is result of clone and assures update triggers do not run
        
        Boolean cloning = false;
        
        if(!newOpps.isEmpty() && newOpps != null){
            for(Opportunity opp : newOpps.values()){
                
                if(oldOpps.containsKey(opp.Id)){
                    Opportunity oldOpp  = oldOpps.get(opp.Id);
                    if(oldOpp.Cloning__c == true || opp.Cloning__c == true){
                        cloning = true;
                    } 
                }else{
                    if(opp.Cloning__c == true){
                        cloning = true;
                    } 
                }
            }
        }
        
        system.debug('this is a clone update '+cloning);
        return cloning;
        
        
    }
    
}