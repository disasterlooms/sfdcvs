public class FileUploadRecord {
    //class allows to upload a file and then
    //update and link the file to the record that will be created
    //post file upload
    
    @auraEnabled
    public static String getId(){        
        
        return userinfo.getUserId();
    }    
    @auraEnabled
    public static Case updateRecords(String whatdoing,String wherepage,String docid,String subject,String mssg,String recid){        
               
        Case c = new Case(subject='test',
                          What_were_you_doing__c = whatdoing,
                         What_Page_were_you_on__c = wherepage,
                         Error_Message_Received__c = mssg,
                         RecordId__c = recid);
        insert c;
        
        system.debug(c);
        system.debug('what '+whatdoing);
        system.debug('where '+wherepage);
        system.debug('docid '+docid);
        
        ContentDocumentLink cd = new ContentDocumentLink ();
        if(docid != null && docid != ''){            
        cd.ContentDocumentId = docid;
        cd.LinkedEntityId = c.Id;                                         
        cd.ShareType = 'I';                                                 
        database.insert(cd,false);
        }        
        
        system.debug(cd);
        
        return c;
    }

}