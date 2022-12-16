public class QuoteUpdates {
    Map<Id, Quote> oldQuotes;
    Map<Id, Quote> newQuotes;
    
    
    public QuoteUpdates(
        Map<Id, Quote> oldTriggerQuotes,
        Map<Id, Quote> newTriggerQuotes) {
            oldQuotes = oldTriggerQuotes;
            newQuotes = newTriggerQuotes;
        }
    public  void inactivated()
    {
        system.debug('inacivated ');
        //if this is not an inactive sku, then do not run query and stop class
        
        Set<Id> oppids = new Set<Id>();
        
        for(Quote newq : newQuotes.values()){
            Quote oldq = oldquotes.get(newq.Id);
            system.debug('old '+oldq.Active__c );
            system.debug('new '+newq.Active__c );
            
            if(oldq.Active__c == true && newq.Active__c == false){
                oppids.add(newq.OpportunityId);
                
            }else{
                return;
            }
        }
        
        
        QuoteUpdates.oppActiveQuote(oppids);
        
        
        
        
    }
    
    //changes for hotswap process 07192019 by Prasad
    
    public static void updateHotSwapFlag(map<id,Quote> newmap,map<id,Quote> oldmap){
        set<id> quoteids = new set<id>();
        for(Quote qo:newmap.values()){
            if(qo.In_Approval_Review__c != oldmap.get(qo.id).In_Approval_Review__c && qo.In_Approval_Review__c != true){
                quoteids.add(qo.id);
            }
        }
       list<QuoteLineItem> lineItems = [select id,QuoteId,Hotswap_Identification__c,Hot_Swap_Flag__c from QuoteLineItem where QuoteId IN:quoteids and Hotswap_Identification__c = true ];
        system.debug('testt------------------>'+lineItems);
        for(QuoteLineItem qli:lineItems){
            if(newmap.containsKey(qli.QuoteId)){
                if(newmap.get(qli.QuoteId).Hot_Swap_Requested__c == true){
                    qli.Hotswap_Identification__c = false;
                    qli.Hot_Swap_Flag__c = true;
                }else{
                     qli.Hotswap_Identification__c = false;
                     qli.Hot_Swap_Flag__c = false;
                }
                
            }
            
        }
             system.debug('testt------------------>'+lineItems);
        update lineItems;
    }
    
    public static void updatequote(List<Quote> records)
    {
        //udpate pricebook if not done already
        system.debug('quotest to update '+records);
        User u = [Select id, firstname,email,lastname,managerid,manager.firstname from user where id =: UserInfo.getUserId()];
        Set<String> opps = new Set<String>();
        for(Quote q : records){
            //q.End_User_Account__c  = q.AccountId;
            opps.add(q.opportunityid);
        }
        
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        Map<String, Opportunity> ops = new Map<String,Opportunity>();
        for(Opportunity o : [Select ID,PriceBook2Id,Opportunity.End_User__c
                             from opportunity where id in: opps]){
                                 ops.put(o.Id, o);
                             }
        
        for(Quote q : records){
            if(ops.containsKey(q.OpportunityId)){
                Opportunity o = ops.get(q.OpportunityId);
                q.PriceBook2Id = o.PriceBook2Id;
                q.Status = 'Needs Review';
                q.Spa_Request_Submitter__c = UserInfo.getUserId();
                q.Requestor_Email__c = UserInfo.getUserEmail();
                q.End_User_Text__c = o.End_User__c;
                String subject = '';
                subject = 'Submission Request Received SPA : '+q.Spa_Name__c;
                String body = '';
                body += u.FirstName+ ',<br/><br/>' ;
                body += 'Your Submission has been sent to the bid desk and is set for review.<br/>thank you <br/><br/>';
                body += 'Notes: '+q.Notes__c +'<br/>';
                body += 'spa id: '+q.SpaId__c +'<br/><br/>';
                
                
                Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
                String[] to = new String[] {u.Email};            
                    //String[] cc = new String[] {Label.AdminEmail};
                    system.debug('subject');
                system.debug(subject);
                mail.setToAddresses(to);
                mail.setSubject(subject);
                mail.setHtmlBody(body);
                mail.setHtmlBody(body);
                //mail.setCcAddresses(cc);
                mail.setTargetObjectId(q.id);   
                mail.setSaveAsActivity(true);
                
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                //
                EmailMessage em = new EmailMessage ();
                em.Subject = 'Submission Request Received SPA : '+q.Spa_Name__c;
                em.ToAddress = u.email;
                em.TextBody = 'test ';
                
                //insert em;
                
                
                
                if(q.Spa_Request_Type__c == 'Bid Register Request'){
                    if( q.Business_Reason_for_Bid_Registration__c == null || q.Scope_of_Bid_Registration__c == null || q.List_of_Work_Activity_c__c == null){
                        q.addError('The fields Business Reason for Bid Registration, Scope of Bid Registration, and List of Work must have valid reasons and be filled out');
                    }else if( q.Business_Reason_for_Bid_Registration__c.length() < 6 || q.Scope_of_Bid_Registration__c.length() < 6 || q.List_of_Work_Activity_c__c.length() < 6){
                        q.addError('The fields Business Reason for Bid Registration, Scope of Bid Registration, and List of Work must have at least 6 Characters and must have valid reasons.');
                    }
                }
            }            
        }
        update oppsToUpdate;
    }
    
    public static void updatequotelines(List<Quote> records)
    {
        Set<String> opps = new Set<String>();
        for(Quote q : records){
            opps.add(q.opportunityid);
        }
        
        Map<String, Opportunity> oproducts = new Map<String,Opportunity>();        
        for(Opportunity ops : [Select ID,primary_quote__c ,(Select PricebookEntryId,Quantity,UnitPrice,PriceBookEntry.IsActive, Competitor_Name_del__c ,
                                                            Competitor_Price_del__c , Competitor_SKU__c , Notes__c, Margin__c   from OpportunityLineItems)
                               from opportunity where id in: opps]){
                                   oproducts.put(ops.Id, ops);
                               }
        Set<Id> quotes = new Set<Id>();
        
        
        List<Opportunity_Partner__c> parts = [Select Id,Quote__c from Opportunity_Partner__c where Opportunity__c in: opps];
        List<OpportunityTeamMember> team = [Select Id,Quote__c from OpportunityTeamMember where OpportunityId in: opps];
        
        List<QuoteLineItem> linesToAdd = new List<QuoteLineItem>();
        
        for(Quote q : records){
            if(oproducts.containsKey(q.OpportunityId) ){
                Opportunity o = oproducts.get(q.opportunityId);
                for(OpportunityLineItem p : o.OpportunityLineItems){
                    if(p.PriceBookEntry.Isactive == True && q.Bypass_Trigger__c != true){
                        QuoteLineItem ql = new QuoteLineItem(QuoteId = q.Id,
                                                             PricebookEntryId = p.PricebookEntryId,
                                                             Quantity = p.Quantity,
                                                             UnitPrice = p.UnitPrice,
                                                             Competitor_Name_del__c =  p.Competitor_Name_del__c,
                                                             Competitor_Price_del__c = p.Competitor_Price_del__c ,
                                                             Competitor_SKU__c = p.Competitor_SKU__c ,
                                                             Notes__c = p.Competitor_SKU__c,
                                                             MarginMultiEdit__c   = p.Margin__c,
                                                             Demo_System_Debug__c  ='From QuoteUpdates');
                        linesToAdd.add(ql);
                        quotes.add(q.Id);                        
                        
                    }
                }
                for(Opportunity_Partner__c p : parts){
                    p.Quote__c = q.Id;                    
                }
                for(OpportunityTeamMember t : team){
                    t.Quote__c = q.Id;                    
                }
            }   
        }
        if(linesToAdd.size()>0){
        try{
             insert linesToAdd;
        }catch(Exception e){
            String msg = e.getMessage();
            String zeromsg = '';
            if(msg.contains('zero')){
                zeromsg = 'Product(s) have a 0 Quantity or 0 Price. Please ensure all products have a non zero in quantity and price and then you can create the SPA ';
            }
            trigger.New[0].addError('Error! '+zeromsg+' Server Message is:  '+msg);
        }
        }
        update parts;
        update team;
        QuoteUpdates.oppQuoteInfo(quotes,trigger.isInsert);
        
        
    }
    public static void spateam(List<Quote> records){
        //not running acctTeam rules on quote creation because it locks records and we will monitor if the acctTeams 
        //should be reset more often. Current set up has bid desk clicking a button that updates the account team when it is not corrected. 
        //
        //note to self, there is a scheduled batch that updates account teams when there are new owners, this may need to be tweaked if account
        //teams are found to be incorrect more often than not
        //
        Boolean runrules = false;
        Set<Opportunity> oppset = new Set<Opportunity>();
        
        for(Quote q : records){
            Opportunity o = new Opportunity(Id = q.OpportunityId);
            oppset.add(o);
        }
        
        
        List<Opportunity> oppteams = new List<Opportunity>(oppset);
        OpportunityTeamAdd.teams(oppteams,runrules);
        system.debug(oppset);
        system.debug('op ids');
        system.debug(oppset.size());
        system.debug('Spa Team Class runing and runnig class opp team add');
        
    }
    public  void upquote()
    {
        //stop update triggers from running
        TriggerContextUtility.setFirstRunFalse();
        User u = [Select id, firstname,email,lastname,managerid,manager.firstname from user where id =: UserInfo.getUserId()];
        Set<String> opps = new Set<String>();
        Set<String> lines = new Set<String>();
        Set<Opportunity> oppset = new Set<Opportunity>();
        
        for(Quote q : newQuotes.values()){
            opps.add(q.OpportunityId);
            lines.add(q.Id);
        }
        
        
        
        
        //List<QuoteLineItem> ql = [Select Id,SPA_Expiration_Date__c ,Quote.ExpirationDate from QuoteLineItem where QuoteId in : lines];
        
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        
        //creating a list of opportunities to cross reference for open tasks
        Set<Id> oppsToTasks = new Set<Id>();
        
        
        Map<String, Opportunity> oppsUpdate = new Map<String, Opportunity>();
        for(Opportunity op : [Select Id,AccountId,OwnerId
                              from Opportunity where Id in : opps]){
                                  oppsUpdate.put(op.Id , op);
                              } 
        
        
        for(Quote q : newQuotes.values()){
            Quote old = oldQuotes.get(q.Id);
            Opportunity o = oppsUpdate.get(q.OpportunityId);
            
            if(q.status == 'Approved'){
                oppsToTasks.add(q.Opportunityid); 
                
            }
            
            if(q.Resubmission_Notes__c != old.Resubmission_Notes__c 
               && q.Resubmission_Notes__c != null && q.Resubmission_Notes__c != ''){
                   q.Status = 'Needs Review';
                   q.Resubmitter__c = UserInfo.getUserId();
                   q.Resubmitter_Email__c = UserInfo.getUserEmail();
                   String body = '';
                   body += u.FirstName+ ',<br/><br/>' ;
                   body += 'Your resubmission has been sent to the bid desk and is set for review.<br/>thank you <br/><br/>';
                   body += 'Resubmission Notes: '+q.Resubmission_Notes__c +'<br/>';
                   body += 'spa id: '+q.SpaId__c +'<br/><br/>';
                   
                   
                   Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
                   String[] to = new String[] {u.Email};            
                       //String[] cc = new String[] {Label.AdminEmail};
                       mail.setToAddresses(to);
                   mail.setSubject('Resubmission Request Received SPA : '+q.Spa_Name__c);
                   mail.setHtmlBody(body);
                   //mail.setCcAddresses(cc);   
                   mail.setSaveAsActivity(true);           
                   Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
               }
            if(q.Resubmission_Notes__c != old.Resubmission_Notes__c 
               && q.Resubmission_Notes__c != null && q.Resubmission_Notes__c != '' & old.Status == 'Approved'){
                   q.Resubmission_Date__c = datetime.now(); 
               }
        }
       
       /*   
       for(QuoteLineItem q : ql){
            Quote newq =  newQuotes.get(q.QuoteId);
        }
        
        update ql;
       */
        
        List<Task> delayed = [Select id, whatid, status from task where whatid in : oppsToTasks and status != 'Completed'
                              and subject like '%SPA Delayed! Missing Data%'];
        
        for(Task t : delayed){ 
            t.status = 'Completed';           
        }
        update delayed;
    }
    @future
    public static void oppActiveQuote(Set<Id> oppids) {
        
        String oppid = '';
        for(Id o : oppids){
            oppid = o;
        }
        
        
        String quoteid = '';
        
        Opportunity opps = [Select id, primary_quote__c ,(Select id from quotes where active__c = true and First_Time_Buyer__c = false order by CreatedDate desc limit 1)
                            ,(Select id, Quote__c from Opportunity_Partners__r),(Select Id, Quote__c from OpportunityTeamMembers) from opportunity where id =: oppid limit 1];
        
        
        system.debug('opp querey results');
        system.debug(opps);
        List<Opportunity_Partner__c> partToUpdate = new List<Opportunity_Partner__c>();
        List<OpportunityTeamMember> TeamToUpdate = new List<OpportunityTeamMember>();
        
        if(opps.quotes.size() > 0){
            
            quoteid = opps.quotes[0].Id;
            opps.Primary_Quote__c = quoteid;
            for(OpportunityTeamMember t : opps.OpportunityTeamMembers){
                t.Quote__c = quoteid;
                TeamToUpdate.add(t);
            }
            for(Opportunity_Partner__c p : opps.Opportunity_Partners__r){
                p.Quote__c = quoteid; 
                partToUpdate.add(p); 
            }
        }
        system.debug('ran the lists to update');
        system.debug(opps);
        system.debug(partToUpdate);
        update opps;
        update partToUpdate;
        update TeamToUpdate;
        
    }
    @future
    public static void oppQuoteInfo(Set<Id> records,Boolean trg) {
        
        List<Quote> quotes = [Select Id, OpportunityId, Spa_Request_Type__c,Specialty_Spa__c  from quote where id in: records];
        
        //need the primary quote so Community members can request a resubmission. This is how they get the quote id
        //on the flow. Eventually, we need to put on lightning and give them access to resubmit the spa
        //directly outside of the opportunity
        
        
        //check if speciality spa before updating primary quote
        Set<Opportunity> opdedup = new Set<Opportunity>();
        for(Quote q : quotes){
            if(q.Specialty_Spa__c == null){
                Opportunity opp = New Opportunity(Id = q.OpportunityId, Primary_Quote__c = q.id );
                opdedup.add(opp);
            }else{
                Opportunity opp = New Opportunity(Id = q.OpportunityId );
                opdedup.add(opp);
            }
            
        }
        
        List<Opportunity> oppsToUpdate = new List<Opportunity>(opdedup);
        
        List<QuoteLineItem> qlines = [Select Id,Product2Id, Competitor_SKU__c,Notes__c,Competitor_Price_del__c,Competitor_Name_del__c,Quote.OpportunityId  from Quotelineitem where quote.opportunityid in : oppsToUpdate];
        
        
        
        //the following code add custom fields from opportunity line items to quote line items..this only needs to be done on creation, not on edit
        //passing the trigger context to avoid running on edit
        if(trg == true){
            Map<String, OpportunityLineItem> olines = new Map<String, OpportunityLineItem>();
            for(OpportunityLineItem o : [Select Id, Product2Id, OpportunityId,Competitor_Name_del__c ,Competitor_Price_del__c ,Competitor_SKU__c ,Notes__c from OpportunityLineItem where
                                         OpportunityId in: oppsToUpdate])
                olines.put(String.valueOf(o.product2Id)+String.valueOf(o.OpportunityId),o);
            for(QuoteLineItem q : qlines){
                if(olines.containsKey(String.valueOf(q.Product2Id)+String.valueOf(q.Quote.OpportunityId))){
                    OpportunityLineItem o = olines.get(String.valueOf(q.Product2Id)+String.valueOf(q.Quote.OpportunityId));
                    q.Competitor_Name_del__c = o.Competitor_Name_del__c;
                    q.Competitor_Price_del__c = o.Competitor_Price_del__c;
                    q.Competitor_SKU__c = o.Competitor_SKU__c;
                    q.Notes__c = o.Notes__c; 
                }            
            }
        }
        
        
        update qlines;
        update oppsToUpdate;
        
    }
}