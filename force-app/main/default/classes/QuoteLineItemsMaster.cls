public class QuoteLineItemsMaster {
    Map<Id, QuoteLineItem> oldQuotes;
    Map<Id, QuoteLineItem> newQuotes;
    List<QuoteLineItem> newTrigger;
    
    
    public QuoteLineItemsMaster(
        Map<Id, QuoteLineItem> oldTriggerQuotes,
        Map<Id, QuoteLineItem> newTriggerQuotes,List<QuoteLineItem> newListQuotes) {
            oldQuotes = oldTriggerQuotes;
            newQuotes = newTriggerQuotes;
            newTrigger = newListQuotes;
        }
    public  void oppteam()
    {
        
        Set<String> opps = new Set<String>();
        
        Set<Opportunity> oppset = new Set<Opportunity>();
        
        for(Quotelineitem q : newTrigger){
            opps.add(q.OpportunityId__c);
        }       
        
        Map<String, Opportunity> oppsUpdate = new Map<String, Opportunity>();
        for(Opportunity op : [Select Id,AccountId,OwnerId,Opportunity.Spa_Request_Submitter__c 
                              from Opportunity where Id in : opps]){
                                  oppsUpdate.put(op.Id , op);
                              }   
        
        for(Quotelineitem q : newTrigger){
            Opportunity o = oppsUpdate.get(q.OpportunityId__c);            
            oppset.add(o);
        }
        List<Opportunity> oppteams = new List<Opportunity>(oppset);
        system.debug('opp team leas');
        system.debug(oppteams);
        
        // comment out the opp teams add team adds.. will need to do this at a different time.. causing errors
        //
        //OpportunityTeamAdd.teams(oppteams);
    }
    
    public static void updateproducts(List<QuoteLineItem> records)
    {
        
       
        
        Set<Id> lines = new Set<Id>();
        for(Quotelineitem q : records){            
            if(!q.IsStateSpa__c){
                return;
            }
            lines.add(q.Id);
        }
        QuoteLineItemsMaster.statesync(lines); 
        
        
        
    }
    
    /*
     * commentening out this class 
     * we do do first time buyer program but this can be in regular spa
     * class also, it happens rarely so bid desk can change quantity
     * without it being too manual ... if need to change, we can
     * add the code in the master class..would rather avoid doing a future 
     * class
     * 
    public static void firsttime(List<QuoteLineItem> records){
        system.debug('first time before');
        
        Set<Id> lines = new Set<Id>();
        for(quotelineitem q : records){
            lines.add(q.Id);
        }
        
        //QuoteLineItemsMaster.firsttimecheck(lines);
        
    }
    */
    public static void spaApprovedCheck(List<QuoteLineItem> records)
    {
        List<QuoteLineItem> qcheck = [Select id, quoteid, quote.status from QuoteLineItem where id in: records];
        
        //if user does not have custom permission to add products, the added products will be deleted.
        Set<Id> lines = new Set<Id>();
        Boolean isEnabled = FeatureManagement.checkPermission('Spa_Quote_Add_Products');
        for(QuoteLineItem q : qcheck){
            if(q.quote.status == 'Approved' && !isEnabled){
                lines.add(q.Id);
            }
            
        }
        if(lines.size()>0)   {
            QuoteLineItemsMaster.deleteLines(lines);
        }  
        
        
    }
    public  void pmapproved()
    {
        Boolean pmapproved = false;
        String quoteid = '';
        Integer pad = 35;
        
        String title = '<b>Special Price Approved by PM or VP See Below </b><p>&nbsp;</p>';
        String col1 = 'SKU';
        String col2 = 'Approved Price';
        String col3 = 'PM Notes (if applicable)';
        String sp = '&nbsp;';
        String head = '';
        
        for(integer i=0; i < pad; i++ ){
            head = head+sp;
        }
        
        String body = title+col1+head+col2+head+col3;
        
        List<QuoteLineItem> pmlines = new List<QuotelineItem>();
        system.debug('pm approved is '+ pmapproved+' '+UserInfo.getUserId());
        for(QuoteLineItem q : newQuotes.values()){
            QuoteLineItem old = oldQuotes.get(q.Id);
            //if the price was updated by product management, set chatter to update for 
            //parent record
            system.debug(q.Approved_Price__c+' price and old '+ old.Approved_Price__c +' and user '+ UserInfo.getUserId());
            
            if(q.Approved_Price__c != old.Approved_Price__c && UserInfo.getUserId() == Label.PMUserId ){  
                pmapproved = true;quoteid = q.quoteId;string notes = '';string prod = q.Product__c;double price = q.Approved_Price__c;if(prod == null){ prod = '';
                }if(prod.length() < pad){Integer addpad = 0;addpad = pad - prod.length();for(integer i=0; i < addpad; i++ ){prod = prod+sp;}}String sprice = String.valueOf(price);if(sprice.length() < pad){Integer addpad = 0;addpad = pad - sprice.length();for(integer i=0; i < addpad; i++ ){sprice = sprice+sp;}}if(q.PM_Approval_Notes__c != null){notes = q.PM_Approval_Notes__c;}body = body+'<p></p>'+prod +'   '+price+'    '+notes;}}
        
        system.debug('pm approved is '+pmapproved);
        
        
        if(pmapproved == true && quoteid != ''){
            system.debug('running post add');
            FeedItem post = new FeedItem(); post.ParentId = quoteid;post.Body = body;post.IsRichText  = true;insert post;Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();String[] toAddresses = new String[] {'viewsonic_bid_desk@viewsonic.com'};mail.setToAddresses(toAddresses);mail.setReplyTo(Label.AdminEmail);mail.setSenderDisplayName('PM SPA Approval');mail.setSubject('PM Approved Spa');mail.setHtmlBody(body+'<p>&nbsp;</p><p>&nbsp;</p>https://viewsonic.lightning.force.com/lightning/r/Quote/'+quoteid+'/view');Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            Quote q = [Select Id, Bid_Desk_to_PM_Notes__c from quote where id =: quoteid limit 1];q.Bid_Desk_to_PM_Notes__c = null;update q;
            
        }
    }
    public  void updateoppproducts()
    {
        TriggerContextUtility.setFirstRunFalse();
        Boolean pmapproved = false;
        String quoteid = '';
        List<QuoteLineItem> pmlines = new List<QuotelineItem>();
        // creating a list of opp line items to update after adding specific items to list
        // creating a map of opp line items from a class that keys the opp id and the
        // product name as keyset values to map with quote line items
        // instead of sending map, will send a list
        List<OpportunityLineItem> linesToUpdate = new List<OpportunityLineItem>();
        List<OpportunityLineItem> linesToInsert = new List<OpportunityLineItem>();
        
        //List<QuoteLineItem> lines = [Select Id,SPA_Approval_Date__c,QuoteId, Quote.OpportunityId,Product2Id,PricebookEntryId,Quantity,UnitPrice,Approved_Price__c,
        //QuoteIsStateSynced__c,Quote.StateSpaSync__c ,OpportunityId__c from quotelineitem where id in: newQuotes.keySet()];
        
        Map<String,OpportunityLineItem> oproducts = OppProductsMap.getLineMap(newTrigger);
        system.debug('pm approved is '+ pmapproved);
        for(QuoteLineItem q : newQuotes.values()){
            QuoteLineItem old = oldQuotes.get(q.Id);
            //if the approved price changes, update the sales price
            system.debug(q.OpportunityId__c + string.valueOf(q.Product2Id));
            system.debug(oproducts);
            system.debug('quote appr price');
            if(oproducts.containsKey(q.OpportunityId__c + string.valueOf(q.Product2Id))
               && q.Approved_Price__c != old.Approved_Price__c){
                   system.debug('found the opp product');
                   OpportunityLineItem oline = oproducts.get(q.OpportunityId__c + string.valueOf(q.Product2Id));
                   OpportunityLineItem lineprice = new OpportunityLineItem(Id = oline.Id,
                                                                           TotalPrice = q.Approved_Price__c* oline.Quantity);
                   
                   linesToUpdate.add(lineprice);
                   system.debug(linesToUpdate);                
               }else if(q.Approved_Price__c != old.Approved_Price__c){
                   //create a new line item and set as likely
                   system.debug('no opp product');
                   try{
                      OpportunityLineItem linenew = new OpportunityLineItem(pricebookentryid  = q.PricebookEntryId,
                                                                         TotalPrice = q.Approved_Price__c* q.Quantity,
                                                                         Quantity = q.Quantity,
                                                                         opportunityid = q.OpportunityId__c,
                                                                         Likely_Purchase__c = true); 
                       linesToInsert.add(linenew);
                   }Catch(Exception e){
                       
                   }
                   
                   
                   
               }
            
            
            //if the price was updated by product management, set chatter to update for 
            //parent record
            system.debug(q.Approved_Price__c+' price and old '+ old.Approved_Price__c +' and user '+ UserInfo.getUserId());
            if(q.Approved_Price__c != old.Approved_Price__c && UserInfo.getUserId() == '005A0000003vRIiIAM' || UserInfo.getUserId() == '005A0000000T6JGIA0'){  
                pmapproved = true;
                
                quoteid = q.quoteId;
                pmlines.add(q);                
            }
            
        }
        
        system.debug('pm approved is '+pmapproved);
        /*

        */
        
        
        
        system.debug(' Checking out the quote line items');
        
        //This class is for state sync spas. using map that concates both product2id and opp id just in case 
        //we add code that needs to sync other information and there is an insert that has more than one opportunity
        //with multiple quote line items this class updates the opp products approval date so that next sync wil not require
        //the bid desk to update the approval date each time since it is derived from the opp products and not the master sync
        //spa...  BTW, this was done because each state spa may have different approval dates and we did not want a conflict on the
        //individual spas,for example if a spa was created in jan and had an approval date of jan, we did not want the june created spa 
        //to have the same approval dates. A spa line item should not be approved before the spa existed. since there is not master approval 
        //date spa, we need a way to get that info and the opp products make the most sense for consistentcy. 
        //
        //grant it we could take the old spa products before deletion but that requirers more time and development to create and this 
        //solution is quicker and as accurate. 
        //
        //future admin, you are more then welcome to update and use the deleted line items from the flow to update spa approval date, but since
        //there is no mapping on visual workflows, you may have to rely on apex. Up to you. 
        
        
        List<SpaStateSync__c> states = new List<SpaStateSync__c>();
        
        //Set<Id> linesToInsert = new Set<ID>();
        
        for(QuoteLineItem l : newTrigger){            
            if(oldQuotes.containsKey(l.id)){
                QuoteLineItem oldl = oldQuotes.get(l.Id);
                system.debug('old '+ oldl.SPA_Approval_Date__c+ ' new '+l.SPA_Approval_Date__c+ ' quote sync '+l.Quote.StateSpaSync__c);
                if(l.Quote.StateSpaSync__c == true){
                    if(oproducts.containsKey(l.OpportunityId__c + string.valueOf(l.Product2Id))){OpportunityLineItem oline = oproducts.get(l.OpportunityId__c + string.valueOf(l.Product2Id));
                        if(l.SPA_Approval_Date__c != oline.SPA_Approval_Date__c){OpportunityLineItem line = new OpportunityLineItem(Id = oline.Id,SPA_Approval_Date__c = l.SPA_Approval_Date__c);
                            
                            
                        }        
                    }else{
                        if(l.SPA_Approval_Date__c != null){SpaStateSync__c s = new SpaStateSync__c (PricbookEntryID__c = l.PricebookEntryId,OpportunityId__c = l.Quote.OpportunityId,ApprovalDate__c =   l.SPA_Approval_Date__c, Quantity__c = l.Quantity ,Approved_Price__c = l.Approved_Price__c);
                            states.add(s);
                            
                        }                        
                    }
                }
            }
        }
        system.debug('check list for records lines to update');
        system.debug(linesToUpdate);
        update linesToUpdate;
        insert linesToInsert;
        insert states;
        //QuoteLineItemsMaster.oppLinesInsert(linesToInsert);
    }
    @future
    public static void statesync(Set<Id> qlines){
        
        List <QuoteLineItem> records = [Select Id, Product2Id, quoteid, opportunityId__c, quote.opportunityId,SPA_Approval_Date__c,IsStateSpa__c
                                        from quotelineitem where id in: qlines];
        
        //This class is for state sync spas. using map that concates both product2id and opp id just in case 
        //we add code that needs to sync other information and there is an insert that has more than one opportunity
        //with multiple quote line items 
        
        Map<String,OpportunityLineItem> oproducts = OppProductsMap.getLineMap(records);            
        List<Quotelineitem> linesToUpdate = new List<QuoteLineItem>();for(QuoteLineItem q : records){if(q.IsStateSpa__c){if(oproducts.containsKey(q.OpportunityId__c + string.valueOf(q.Product2Id))){
                    OpportunityLineItem o = oproducts.get(q.OpportunityId__c + string.valueOf(q.Product2Id));QuoteLineItem ql = new QuoteLineItem(Id = q.Id,SPA_Approval_Date__c = o.SPA_Approval_Date__c);
                    linesToUpdate.add(ql);
                }                
            }
        }
        
        update linesToUpdate;
    }
    @future
    public static void deleteLines(Set<Id> qlines){
        
        List<QuoteLineItem> lines = [Select Id from QuoteLineItem where id in : qlines];
        
        delete lines;
        
    }
    /*
    @future
    public static void firsttimecheck(Set<Id> qlines){
        system.debug('furture lines '+qlines);
        List<QuoteLineItem> lines = [Select Id,Quantity,Quote.First_Time_Buyer__c from QuoteLineItem where id in : qlines];
        
        for(quotelineitem q : lines){
            if(q.Quote.First_Time_Buyer__c == true){
                q.Quantity = 1;
            }
        }
        system.debug('update lines' +lines);
        update lines;
        
    }
    */
    @future
    public static void oppLinesInsert(Set<Id> qlines){
        
        //List<QuoteLineItem> lines = [Select id, pricebookentryid, quote.opportunity.id, quantity, unitprice, SPA_Approval_Date__c from quotelineitem where id in: qlines];
        
        ///List<OpportunityLineItem> linesToInsert = new List <OpportunityLineItem>();
        //for(QuoteLineItem l : lines){
        // OpportunityLineItem lineinsert = new OpportunityLineItem(PricebookentryId = l.PricebookEntryId,
        //Quantity = l.Quantity,
        //unitprice = l.UnitPrice,
        //opportunityId = l.Quote.OpportunityId,
        //SPA_Approval_Date__c = l.SPA_Approval_Date__c,
        //IsSyncFromQuote__c  = true);
        //linesToInsert.add(lineinsert);
        
        //}           
        //database.insert(linesToInsert, false); 
        
    }
    
    
}