public class UpdateOppsSchedules {
    @AuraEnabled
   public static String updateopps(List<OpportunityLineItem> opps,List<OpportunityLineItemSchedule> lines){  
    
        //save the opportuntiy and line items in collections after clicking on save
     
       String  errormessages = '';
       Integer numerrors = 0;
       Integer numsuccess = 0;
       Integer numopps = 1;
        
        List<Database.SaveResult> updateResults = Database.update(opps, false);
                for(Integer i=0;i<updateResults.size();i++){
                    if (updateResults.get(i).isSuccess()){
                        updateResults.get(i).getId();
                        system.debug('success id '+ opps.get(i).Name);
                        numsuccess += 1;
                
                    }else if (!updateResults.get(i).isSuccess()){
                        // DML operation failed
                        Database.Error error = updateResults.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        opps.get(i);//failed record from the list
                        system.debug('Failed ID '+opps.get(i).Name);
                        system.debug('Message '+ failedDML);
                        numerrors += 1;
                     }
                }
        
        system.debug('number of errors '+numerrors+ ' successes '+numsuccess);
        
        List<Database.SaveResult> updateResultsp = Database.update(lines, false);
                for(Integer i=0;i<updateResultsp.size();i++){
                    if (updateResultsp.get(i).isSuccess()){
                        updateResultsp.get(i).getId();
                        system.debug('success id '+ lines.get(i).Id);
                        numsuccess += 1;
                    }else if (!updateResultsp.get(i).isSuccess()){
                        // DML operation failed
                        Database.Error error = updateResultsp.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        lines.get(i);//failed record from the list
                        system.debug('Failed ID '+lines.get(i).Id);
                        system.debug('Message '+ failedDML);
                        numerrors += 1;
                        errormessages = 'Failed ID '+lines.get(i).Id;
                     }
                }
       
       return errormessages;
 } 

    

}