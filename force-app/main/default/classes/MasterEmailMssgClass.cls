public class MasterEmailMssgClass{
    Map<Id,EmailMessage> oldmssgs;
    Map<Id,EmailMessage> newmssgs;
    public MasterEmailMssgClass(Map<Id,EmailMessage> omssgs,Map<Id,EmailMessage> nmssgs){
        oldmssgs = omssgs;
        newmssgs = nmssgs;        
    }
    public void reminder(){
        
    }
     public static void spaTask(List<EmailMessage> records)
    {
        // need to create a task and update the quote when a needs info
        // email is sent to the most recent spa requestor
        // the recent spa requester will need to be added to trigger and may need to be 
        // manually updated since it could come from an external community partner 
        // or an inactive sales user. 
        // 
        // Getting the quote id and making sure it is the need info email from the system. 
        // then will create a task and update the quote status
        // The status is linked to a modal that will pop up and show users their delayed quotes
        // ...eventually telling them why as well.   (; hope you found this useful....
        //
        // Created maps in case we want to build out the triggers. figured build the base now and 
        // have the blocks for the future even if never used. 
        // 
        //  too many dev notes have you hurting? Watch kitten and/or puppy videos...the answer to most questions.
        //  
        //    
        Set<String> spaid = new Set<String>();
        for(EmailMessage e : records){
            if(e.subject.startsWith('Need Info for SPA')&& e.RelatedToId != null ){
             spaid.add(e.RelatedToId);   
                
            }
        }        
        Map<Id,Quote> quotes =  new Map<Id,Quote>();
        for(Quote q: [Select id, Resubmitter__c,name,CreatedbyId,OpportunityId   from quote where id in: spaid])
           quotes.put(q.Id, q);
        
        List<Quote> quotesToUpdate = new List <Quote>();
        List<Task> taskstoadd = new List<Task>(); 
        String qname = '';
        String sub = '';
        for(EmailMessage e : records){
            if(quotes.containsKey(e.RelatedToId) ){               
             	Quote q = quotes.get(e.RelatedToId);
                qname = q.name;
                if(q.Resubmitter__c == null){
                    sub = q.CreatedById;
                }else{
                    sub = q.Resubmitter__c;
                }
                Task t = new task(Subject= 'SPA Delayed! Missing Data',
                              	  ownerid = sub ,
                                  priority = 'High ',
                                  ActivityDate  = date.today(),
                                  Type = 'To Do',
                                  description = e.HtmlBody ,
                                  WhatId = q.OpportunityId);                
                taskstoadd.add(t);
                Quote qu = new Quote(Id = q.Id,
                                     Status = 'Delayed Info Missing',
                                    Info_Requested_Date__c = date.today());
                quotesToUpdate.add(qu);                
            }
        }        
        try{
            insert taskstoadd;
        }catch(Exception e){
            String t = 'task not created due for quote '+qname;
            AdminErrorMessage.SendError(e, t);
        }
        
        update quotesToUpdate;
        
    }

}