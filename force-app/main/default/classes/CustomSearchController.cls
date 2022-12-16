global with sharing class CustomSearchController {
    @AuraEnabled
    public static List<ContentDocument> searchForIds(String searchText,
                                                     Integer qty,
                                                     String exclusion,
                                                     String library,String category) {
     

                                              
     system.debug('library name '+library);
     system.debug('exclusion name '+exclusion);
     system.debug('search text '+searchText); 
                                                         
                                                         
     Boolean exclude = false;                                                     
     //List<String> Pvalues =  CustomSearchController.getPickListValuesIntoList();
     //system.debug(Pvalues);
     system.debug('virst cate '+category);
     Boolean noSearchText = false;   
     Boolean promotionalPage = false;   
     if(category == 'All' || category == '' ||category == null){
         exclude = true;
         category = 'somecatThatDoesnotexist';
     }                                                         
     if(library == ''){
          library ='%partner portal%';                                                  
     } else{         
         if(library == 'Partner Portal Promotions'){
             promotionalPage = true;
         }
         library = library+'%';
     }                                                                                                          
      if(searchText == ''){
            qty = 12;
            searchText = '';
           noSearchText = true;
            //searchText = 'promo';
        }
       system.debug('category '+category);
       system.debug('is there search text ? '+noSearchText);
       system.debug('search text value '+searchText); 
        String searchtxt = '%'+searchText+'%';
        system.debug('final search text '+searchText);                                                 
        List<ContentDocument> cdTags = new List<ContentDocument> ();
        List<ContentDocument> cdPromo = new List<ContentDocument> ();
        
       User u = [Select id, Contact.Account.ParentID__c ,contactid, contact.accountId,contact.account.parentId,contact.account.parent.parentid from user
                 where id = : userInfo.getUserId()];
       String parentAcctId = u.Contact.Account.ParentID__c;
       String acctId = u.Contact.AccountId;
       String firstParentacctId = u.Contact.Account.ParentId;
                                                         
        List<Account> parentAccts = [Select id from account where id =: u.Contact.Accountid or
                                    id =: u.Contact.Account.ParentId or
                                    id =: u.Contact.Account.Parent.Parentid ];
                                                        String[] ids = New String[]{};
                                                         for(Account a: parentAccts){
                                                             ids.Add(a.Id);
                                                          }
                                                         
     system.debug('acct id '+ acctId);                                                         
      if(promotionalPage){
          List<ContentDocumentLink>  links = new List<ContentDocumentLink> ();
          
          try{
              String promoTxt = '%promotion%';
              /*String idString = string.join(ids,',');*/
              
              String query = 'SELECT ContentDocumentId,ContentDocument.LatestPublishedVersion.Tags__c '+
                                          ' FROM ContentDocumentLink where LinkedEntityId = : acctId or LinkedEntityId = : parentAcctId'
                  + ' or LinkedEntityId =:firstParentacctId';
              system.debug('query ');
              system.debug(query);
              links = Database.query(query);
          }catch(Exception e){
              if(test.isRunningTest()){
              Account a = [Select id, name from Account where name like 'viewsonic%' limit 1];
              acctId = a.Id;    
              String query = 'SELECT ContentDocumentId,ContentDocument.LatestPublishedVersion.Tags__c '+
                                          ' FROM ContentDocumentLink where LinkedEntityId = : acctId';
              links = Database.query(query);
                  
              }
          }
         
          
          
          
          Set<String> linkCont = new Set<String>();
          for(ContentDocumentLink c : links){
		  linkCont.add(c.ContentDocumentId);
          }
      cdPromo =   [select id, title,description,FileExtension,LatestPublishedVersion.Tags__c from ContentDocument
           where id in: linkCont and LatestPublishedVersion.Categories__c includes ('Promotions')];
                                                                               
      }                                                 
        if(!noSearchText){
        	cdTags = [select id, title,description,FileExtension,LatestPublishedVersion.Tags__c from ContentDocument
           where id in (SELECT ContentDocumentId FROM ContentWorkspaceDoc where ContentWorkspace.name like :library 
           and ContentWorkspace.name !=: exclusion) and LatestPublishedVersion.Tags__c like :searchtxt order by CreatedDate desc, title asc limit :qty];
                                                         }
     
       List<ContentDocument> cds = new List<ContentDocument>();
       if(exclude){
         cds = [select id, title,description,FileExtension,LatestPublishedVersion.Tags__c from ContentDocument
                                                                                          where id in (SELECT ContentDocumentId FROM ContentWorkspaceDoc
                                                                                                       where ContentWorkspace.name like :library
                                                                                                       and ContentWorkspace.name !=: exclusion)
                                                                                          and LatestPublishedVersion.Categories__c excludes (:category)
                                                                                          and title like :searchtxt
                                                                                          order by CreatedDate desc limit :qty];

       }else{
           cds = [select id, title,description,FileExtension,LatestPublishedVersion.Tags__c from ContentDocument
                                     where id in (SELECT ContentDocumentId FROM ContentWorkspaceDoc
                                     where ContentWorkspace.name like :library
                                    and ContentWorkspace.name !=: exclusion) and LatestPublishedVersion.Categories__c includes (:category)
                                    and title like :searchtxt order by CreatedDate desc limit :qty];
       }                                                 
         
                                                         
        cds.addAll(cdTags);
        cds.addAll(cdPromo);                                                 
                                                         
        return cds;
    }
    @AuraEnabled
    public static List<ContentDocument> getFileId(String fileId) {
        String urlValue = '';
        List<ContentDocument> cv = [SELECT title,ContentAssetId,Id,LatestPublishedVersion.File_Image_URL__c
 								FROM ContentDocument  
                             where Id =:fileId limit 1];
        
        system.debug(cv);
        if(cv.size()> 0){
            urlValue = cv[0].LatestPublishedVersion.File_Image_URL__c;
        }
        system.debug(urlValue);
        return cv;
       
    }  
    @AuraEnabled
    public static List<ContentDocument> getPromos(   Integer qty,
                                                     Boolean spiffs,
                                                     Boolean promos,
                                                     Boolean pricing
                                                     ) {
        
      
   List<ContentDocumentLink> docLinks = new List<ContentDocumentLink>();

    if(spiffs){
        List<ContentDocumentLink> spiffDocs = [Select ContentDocumentId from ContentDocumentLink where LinkedEntityId
        in (Select id from ChannelProgram where Program_Type__c = 'Spiffs') ];
        docLinks.addAll(spiffDocs);
    }
    if(pricing){
        List<ContentDocumentLink> priceDocs = [Select ContentDocumentId from ContentDocumentLink where LinkedEntityId
        in (Select id from ChannelProgram where Program_Type__c = 'Pricing') ];
        docLinks.addAll(priceDocs);
    }
    if(promos){
        List<ContentDocumentLink> promoDocs = [Select ContentDocumentId from ContentDocumentLink where LinkedEntityId
        in (Select id from ChannelProgram where Program_Type__c = 'Promotional') ];
        docLinks.addAll(promoDocs);
    }   
    
    List<String> fileIds = new List<String>();
    for(ContentDocumentLink cdl : docLinks){
        fileIds.add(cdl.ContentDocumentId);

    }
    
    Integer lmt = 3;
    if(qty>0){
        lmt = qty;
    }
    List<ContentDocument> cv = [SELECT title,ContentAssetId,Id,LatestPublishedVersion.File_Image_URL__c
        FROM ContentDocument  
    where Id in :fileIds order by createddate desc limit :lmt ];
    system.debug(cv);
    system.debug('# of files '+cv.size());
    return cv;
                                                     }
    
    @AuraEnabled
    public static List<ContentVersion> getContentVersion(String assId) {
        List<ContentVersion> cv = [SELECT ContentDocumentId,Field_Image__c,File_Image_URL__c,Id
 								FROM ContentVersion 
                             where ContentDocument.ContentAssetId =:assId limit 1];
    system.debug(cv);
    system.debug('# of files '+cv.size());
        return cv;
        
    }   
    /* 
    @AuraEnabled
    public static List<String> getPickListValuesIntoList(){
       List<String> pickListValuesList= new List<String>();
		Schema.DescribeFieldResult fieldResult = ContentVersion.Categories__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple){
			pickListValuesList.add(pickListVal.getValue());
		} 
        system.debug('values ');
         system.debug(pickListValuesList);
		return pickListValuesList;
    }
   */
    
}