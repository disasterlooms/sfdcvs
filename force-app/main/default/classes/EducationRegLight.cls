global without sharing class EducationRegLight {
    @AuraEnabled
    global static Account updateAcct(Account acct){
        
        update acct;        
        return acct;
    }
    @AuraEnabled
    global static Account getAccount(String recid){
        system.debug('recid');
        system.debug(recid);
        CustomerKeys__mdt k = [SELECT key__c  FROM CustomerKeys__mdt  limit 1];
        
        //String decoded =
        Blob key = Blob.valueOf(k.key__c);
        Blob blobData = EncodingUtil.base64Decode(recid);
        
        Blob decryptedBlob = Crypto.decryptWithManagedIV('AES128', key, blobData);		
        string decodedId = decryptedBlob.toString();
        String urldcrpt = 'https://c.visualforce.com/apex/visualforcepage?id='+decodedId;
        
        system.debug(urldcrpt); 
        
        
        Account a =[Select id, Name,(Select id, firstname, lastname, email from Contacts),Industry,Type,
                    Owner.Name,OwnerId,owner.email,owner.manager.name,owner.manager.email,owner.phone,owner.manager.phone,
                    owner.MobilePhone ,owner.manager.MobilePhone,BillingCity,BillingState,County__c,BillingPostalCode, LRP_ViewBoard_Exists__c  
                    from account 
                    where id =: decodedId];
        system.debug('returned acc ');
        system.debug(a);
        return a;
    }
    @AuraEnabled
    global static List<Contact> getContacts(String accId){
        system.debug('acc id '+accId);
        List<Contact> cons = [Select id,Name,Email,Title,Marketing_Post_Sales__c,ViewBoard_User_Type__c,
                              Account.Name,MailingState,Account.Parent.Name,FirstName,LastName
                              from Contact 
                              where AccountId =: accId];
        return cons;
        
        
    }
    @AuraEnabled
    global static void updateContacts( List<Contact> cons){
        
        update cons;
        
    }
    @AuraEnabled
    global static List<Contact> createCons( List<Contact> con){
        Set<String> conEmails = new Set<String>();
        for(Contact cn : con){
            conEmails.add(cn.Email);    
        } 
        
        Map<String,Contact> conMap = new Map<String,Contact>();
        for(Contact c : [Select id, FirstName,Email from Contact where Email in :conEmails]){
            conMap.put(c.Email,c);
        }
        List<Contact> cons = new List<Contact>();
        
        for(Contact c : con){
            if(c.Email != '' && c.FirstName != '' && c.AccountId != null && c.Email.contains('@')){
                Id conid = null;                   
                if(conMap.containsKey(c.Email)){
                    Contact cm = conMap.get(c.Email);
                    conid = cm.Id;
                }
                Contact newcon = new Contact();
                newcon.Id = conid;
                newcon.FirstName = c.FirstName;
                newcon.LastName = c.LastName;
                newcon.Phone = c.Phone;
                newcon.Email = c.Email;
                newcon.AccountId = c.AccountId;
                newcon.ViewBoard_User_Type__c = c.ViewBoard_User_Type__c;
                newcon.Marketing_Post_Sales__c = true;
                cons.add(newcon);
            }
        }
        
        Account a = [Select id, LRP_ViewBoard_Exists__c,name,description from account where id =: con[0].AccountId];
        
        try{
            upsert cons;
            a.LRP_ViewBoard_Exists__c = true;
            update a;
        }catch(Exception e){
            String t = 'Error on Public education site';
            AdminErrorMessage.SendError(e, t);
            throw new AuraHandledException('Admin has been notified and will reach out.'+ ' Admin can be reached @ '
                                           +Label.AdminEmail+ ' Error message is : '+
                                           + e.getMessage());
        }
        
        return cons;
        
    }
    @AuraEnabled
    global static Contact createCon( Contact con){
        insert con;
        return con;
        
    }
    @AuraEnabled
    global static List<VSA_Open_Order__c> getPurchaseOrder(String acct){
        String po = '';
        
        List<VSA_Open_Order__c> orders = [Select PO_Number__c ,Account__c, Ship_Date__c   from VSA_Open_Order__c  where 
                                             Account__c  = : acct order by Ship_Date__c  desc];
         
        
        return orders;
        
    }
    
    @AuraEnabled
    global static Order upOrder(Order o){
        try{
            
            List<Order> relatedOrder = [select id, AccountId, Devices_Students_Use__c ,Devices_You_Use__c ,
                                        What_Browsers_do_you_Use__c , What_type_of_Casting_would_you_like__c , 
                                        Which_do_you_want_to_focus_on__c from order where accountid =: o.AccountId];
            for(Order rod: relatedOrder){
                rod.Devices_Students_Use__c = o.Devices_Students_Use__c;
                rod.Devices_You_Use__c = o.Devices_You_Use__c;
                rod.What_Browsers_do_you_Use__c = o.What_Browsers_do_you_Use__c;
                rod.What_type_of_Casting_would_you_like__c = o.What_type_of_Casting_would_you_like__c;
                rod.Which_do_you_want_to_focus_on__c = o.Which_do_you_want_to_focus_on__c;
            }  
            database.update(relatedorder, false);
            
            upsert o;
            
            List<Task> ts = new List<Task>();
            User pdtrainer = [Select id,email,firstname,lastname from user where isactive = true and name like '%blake%' and name like '%everhart%' limit 1];
            
            Task t = new Task();
            t.subject = 'Updated PD Order';
            t.Type = 'To Do';
            t.ActivityDate = date.today();
            t.ownerid = pdtrainer.Id;
            t.whatid = o.Id;            
            ts.add(t);
            
            
            Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {pdtrainer.email};
                mail.setToAddresses(toAddresses);
            mail.setReplyTo(pdtrainer.email);
            mail.setSenderDisplayName('EDU Portal Order Update');
            mail.setSubject('EDU Portal Order Update');
            mail.setPlainTextBody('PD order was updated through portal. Please check order Number '+o.OrderNumber+ '      https://viewsonic.my.salesforce.com/'+o.Id);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            insert ts;
        }catch(Exception e){
            
            throw new AuraHandledException('Admin has been notified and will reach out.'+ ' Admin can be reached @ '
                                           +Label.AdminEmail+ ' Error message is : '+
                                           + e.getMessage() + 'error ..heere is the order '+ o +' '+ o.Status+ ' order info here '+ o.Id);
            
            
        }
        
        return o;
        
    }

    @AuraEnabled
    global static Order createOrder(Order o){
        
                /*
        List<Order> ord = [Select id, accountId from Order 
        where Accountid = : a.Id and status != 'Completed ' and
        status != 'Activated'];
        
        if(ord.size()> 0){
        o.Id = ord[0].Id;
        }
        */
        
        try{
            
            List<Order> relatedOrder = [select id, AccountId, Devices_Students_Use__c ,Devices_You_Use__c ,
                                        What_Browsers_do_you_Use__c , What_type_of_Casting_would_you_like__c , 
                                        Which_do_you_want_to_focus_on__c from order where accountid =: o.AccountId];
            for(Order rod: relatedOrder){
                rod.Devices_Students_Use__c = o.Devices_Students_Use__c;
                rod.Devices_You_Use__c = o.Devices_You_Use__c;
                rod.What_Browsers_do_you_Use__c = o.What_Browsers_do_you_Use__c;
                rod.What_type_of_Casting_would_you_like__c = o.What_type_of_Casting_would_you_like__c;
                rod.Which_do_you_want_to_focus_on__c = o.Which_do_you_want_to_focus_on__c;
            }  
            database.update(relatedorder, false);
            
            upsert o;
            
            List<Task> ts = new List<Task>();
            User pdtrainer = [Select id,email,firstname,lastname from user where isactive = true and name like '%blake%' and name like '%everhart%' limit 1];
            
            Task t = new Task();
            t.subject = 'Updated PD Order';
            t.Type = 'To Do';
            t.ActivityDate = date.today();
            t.ownerid = pdtrainer.Id;
            t.whatid = o.Id;            
            ts.add(t);
            
            
            Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {pdtrainer.email};
                mail.setToAddresses(toAddresses);
            mail.setReplyTo(pdtrainer.email);
            mail.setSenderDisplayName('EDU Portal Order Update');
            mail.setSubject('EDU Portal Order Update');
            mail.setPlainTextBody('PD order was updated through portal. Please check order Number '+o.OrderNumber+ '      https://viewsonic.my.salesforce.com/'+o.Id);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            insert ts;
        }catch(Exception e){
            
            throw new AuraHandledException('Admin has been notified and will reach out.'+ ' Admin can be reached @ '
                                           +Label.AdminEmail+ ' Error message is : '+
                                           + e.getMessage() + 'error ..heere is the order '+ o +' '+ o.Status+ ' order info here '+ o.Id);
            
            
        }
        
        return o;
        
    }
    @AuraEnabled
    global static List<Order> editTraining(String orderId, String acctId){
        List<Order> orders = new List<Order>();        
        List<Order> acctOrders = new List<Order>();
        
        DescribeSObjectResult describeResult = Order.getSObjectType().getDescribe();	
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );	
        
        try{
            String query =	  ' SELECT ' +	      String.join( fieldNames, ',' ) +	  ',Account.Name FROM ' +	      describeResult.getName()	+' where Id = : orderId';
            orders = Database.query( query );
            
            String query2 =	  ' SELECT ' +	      String.join( fieldNames, ',' ) +	  ',Account.Name FROM ' +	      describeResult.getName()	+' where AccountId = : acctId and Devices_You_Use__c != null';
            acctOrders = Database.query( query2 );            
            
        }catch(Exception e){
            
                throw new AuraHandledException('Admin has been notified and will reach out.'+ ' Admin can be reached @ '
                                               +Label.AdminEmail+ ' Error message is : '+
                                               + e.getMessage() + 'error ..here is the order '+ orders);
        }
        
        if(orders.size()> 0 && acctOrders.size()> 0){
            if(orders[0].Devices_You_Use__c == null){
                orders[0].Devices_You_Use__c = acctOrders[0].Devices_You_Use__c;
                orders[0].Devices_Students_Use__c  = acctOrders[0].Devices_Students_Use__c ;
                orders[0].What_Browsers_do_you_Use__c  = acctOrders[0].What_Browsers_do_you_Use__c ;  
                orders[0].What_type_of_Casting_would_you_like__c  = acctOrders[0].What_type_of_Casting_would_you_like__c ;  
                orders[0].Which_do_you_want_to_focus_on__c  = acctOrders[0].Which_do_you_want_to_focus_on__c;  
            } 
        }else if(orders.size()== 0 && acctOrders.size()> 0){
            Order od = new Order();
            od.Devices_You_Use__c = acctOrders[0].Devices_You_Use__c;
            od.Devices_Students_Use__c  = acctOrders[0].Devices_Students_Use__c ;
            od.What_Browsers_do_you_Use__c  = acctOrders[0].What_Browsers_do_you_Use__c ;  
            od.What_type_of_Casting_would_you_like__c  = acctOrders[0].What_type_of_Casting_would_you_like__c ;  
            od.Which_do_you_want_to_focus_on__c  = acctOrders[0].Which_do_you_want_to_focus_on__c;
            od.AccountId = acctOrders[0].AccountId;
            od.Status = 'Draft';
            orders.add(od);
            
        }
        
        
        
        
        return orders;
         
    }
    @AuraEnabled
    global static List<Order> getTrainings(String acctId){
        
        List<SObject> orders = new List<SObject>();
        DescribeSObjectResult describeResult = Order.getSObjectType().getDescribe();	
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );	
        try{
            String query =	  ' SELECT ' +	      String.join( fieldNames, ',' ) +	  ',Account.Name FROM ' +	      describeResult.getName()	+' where accountid = : acctId';
            orders = Database.query( query );
        }catch(Exception e){
            
                throw new AuraHandledException('Admin has been notified and will reach out.'+ ' Admin can be reached @ '
                                               +Label.AdminEmail+ ' Error message is : '+
                                               + e.getMessage() + 'error ..here is the order '+ orders);
        }
        
        return orders;
        
    }
    
}