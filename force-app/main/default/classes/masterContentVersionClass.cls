public class masterContentVersionClass{
    // These variables store Trigger.oldMap and Trigger.newMap
    Map<Id, ContentVersion> oldContent;
    Map<Id, ContentVersion> newContent;   
    
    public masterContentVersionClass(
        Map<Id, ContentVersion> oldTriggerContent, 
        Map<Id, ContentVersion> newTriggerContent) {
            oldContent = oldTriggerContent;
            newContent = newTriggerContent;
        }
    
    public static void moveWNine(List<ContentVersion> records){
        
        List<String> work = new List<String>();
        
        for(ContentVersion cv : records){
            if(!cv.ignoreTrigger__c){
                work.add(cv.Library__c);
            }
           
        }
        
        // List<ContentWorkspace> wk = [SELECT Id,Name FROM ContentWorkspace where name in: work limit 1];
        
        Map<String,ContentWorkspace> wMap = new Map<String,ContentWorkspace>();
        
        for(ContentWorkspace cw : [SELECT Id,Name FROM ContentWorkspace where name in: work limit 1]){
            wMap.put(cw.Name,cw);
        }
        
        List<String> links = new List<String>();        
        
        List<ContentWorkspaceDoc> contents = new List<ContentWorkspaceDoc>();
        
        String contId = '';
        
        for(ContentVersion cd : records){
            if(wMap.size()>0&& !cd.ignoreTrigger__c){                
                contid = cd.ContentDocumentId;
            }   
        }
        
        List<String> conIds = new List<String>();
        
        List<ContentDocumentLink> cdl = [Select id, LinkedEntityId , ContentDocumentId from ContentDocumentLink where ContentDocumentId =: contId];
        for(ContentDocumentLink c : cdl){
            conIds.add(c.LinkedEntityId);
        }
        
        String entityName = '';
        List<Contact> c = [Select id,name,firstname,lastname, portalW9__c ,PortalW9Date__c  from Contact where id in: conIds ];
        List<Account> a = [Select id,name from Account where id in: conIds ];
        if(c.size()>0){
            entityName = c[0].Name;
            c[0].PortalW9Date__c =date.today();
            c[0].portalW9__c =true;
            update c[0];
        }else if(a.size()>0){
            entityName = a[0].Name;
        }
        
        List<ContentDocumentLink> oldLinks = new List<ContentDocumentLink>();
        
        List<ContentDocument> cDocumentstoUpdate = new List<ContentDocument>();
        
        List<ContentDocumentLink> newLinks = new List<ContentDocumentLink>();
        for(ContentVersion cd : records){    
            if(wMap.containsKey(cd.Library__c)){
                ContentWorkspace cwp = wMap.get(cd.Library__c);
                contid = cd.ContentDocumentId;
                if(cd.Library__c == 'W9' && wMap.size()>0){                        
                    ContentWorkspaceDoc cw = new ContentWorkspaceDoc();
                    cw.ContentDocumentId = cd.ContentDocumentId;
                    cw.ContentWorkspaceId = cwp.Id;
                    contents.add(cw);
                    cd.Description = 'Contact Id: '+cdl[0].LinkedEntityId + ' Contact name: '+ entityName;
                    if(c.size()>0){
                        cd.Title = c[0].Name+' W9';
                    }
                }else{
                    ContentDocumentLink conDocLink = new ContentDocumentLink();
                    conDocLink.ContentDocumentId = cd.ContentDocumentId;
                    conDocLink.LinkedEntityId = cwp.Id;
                    newLinks.add(conDocLink);
                    ContentDocument cDoc = [Select id , parentId from contentDocument where id =:cd.ContentDocumentId];
                    cDoc.ParentId = cwp.Id;
                    cDocumentstoUpdate.add(cDoc);
                    
                }      
            }   
            
        }   
        
        insert newLinks;
        update cDocumentstoUpdate;
        try{
            insert contents; 
        }catch(Exception e){
            String recId = null;String objType  ='ContentDocument';String apexClass ='masterContentVersionClass';String errMessage = e.getmessage();
            apexerrorlog.logError(recId, objType, apexClass, errMessage);
        }
        
        delete cdl;
        
    }
}