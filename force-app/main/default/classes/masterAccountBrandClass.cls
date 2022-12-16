public class masterAccountBrandClass{
    // These variables store Trigger.oldMap and Trigger.newMap
    Map<Id, AccountBrand> oldBrands;
    Map<Id, AccountBrand> newBrands;
    
    
    public masterAccountBrandClass(
        Map<Id, AccountBrand> oldTriggerBrands, 
        Map<Id, AccountBrand> newTriggerBrands) {
            oldBrands = oldTriggerBrands;
            newBrands = newTriggerBrands;
        }
    
    // The one method your master trigger will call
    public static void updatedLogo(List<AccountBrand> records){
        
        // get the assetid
        // get the fileId
        // 
        // then get the contentversion id
        // 
        List<String> assIds = new List<String>();
        for(AccountBrand ab : records){
            assIds.add(ab.LogoId);
        }
        Map<String, ContentVersion> cvs = new Map<String, ContentVersion>();
        
        for(ContentVersion c : [SELECT ContentDocument.ContentAssetId, ContentDocumentId,Field_Image__c,File_Image_URL__c,Id
                                FROM ContentVersion 
                                where ContentDocument.ContentAssetId in: assIds]){
                                    cvs.put(c.ContentDocument.ContentAssetId, c);
                                }
        for(AccountBrand ab : records){
            if(cvs.containsKey(ab.LogoId)){
                ContentVersion c = cvs.get(ab.LogoId);                
                String s1 = c.File_Image_URL__c;
                String target = 'https://partner.viewsonic.com';
                String replacement = 'https://viewsonic.my.salesforce.com';
                String s2 = s1.replace(target, replacement);
                //c.File_Image_URL__c.replace('https://partner.viewsonic.com', 'https://viewsonic.my.salesforce.com');
                ab.fileURLThumbnail__c = s2;
                ab.FileId__c = c.ContentDocumentId;
            }
        }
    }
}