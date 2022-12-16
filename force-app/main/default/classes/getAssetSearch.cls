public without sharing class getAssetSearch {
    @AuraEnabled
    public static List<Asset> getSerialNumber(String wherestmnt,String addfields,
                                              string orderstmnt,String spiffId,
                                              String limitstmt,Boolean spiffSearch,
                                             String spaId){       
        system.debug('spiff is ' +spiffId);
        system.debug('where is ' +wherestmnt);
        system.debug('order is ' +orderstmnt);
        system.debug('limit is ' +limitstmt);
                                                  
		if(limitstmt == null){
            limitstmt = ' limit 100';
		} 
                                                  
		if(wherestmnt == null){
            wherestmnt = ' ';
		} 
        if(orderstmnt == null){
            orderstmnt = ' ';
		} 
                                                  
        system.debug('where is ' +wherestmnt);
        system.debug('order is ' +orderstmnt);
        system.debug('limit is ' +limitstmt);
        DescribeSObjectResult describeResult = Asset.getSObjectType().getDescribe();        
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        
        //if spiff page, use the spiff info to search just spiffs.         
        String resellerParent = '';
        
        system.debug('spiff id '+spiffId );
        if(spiffId == null || spiffId == ''){
            //do nothing 
            system.debug('spiff id does not exist');
        } else{
            Account a = [Select id, name, parentId from account where id in
                         (Select Requester_Company__c from Spiff_Request__c where id = : SpiffId) limit 1];
            if(a.parentId == null ){
                resellerParent = a.Id;
            }else{
                resellerParent = a.ParentId;
            }
        }
        
        system.debug('parent id '+ resellerParent);
        
        
        if(spiffSearch){
           wherestmnt =  ' WHERE Reseller_Account__c = : resellerParent ';
        }
         system.debug('where statement'+ wherestmnt);
        
        String query =		  ' SELECT ' +		      String.join( fieldNames, ',' ) +	addfields +	  ' FROM '
            +		      describeResult.getName()	+ wherestmnt+ orderstmnt+limitstmt;		
        // return generic list of sobjects or typecast to expected type
        // 
        system.debug('query below');
        system.debug(query);
        system.debug(query.substring(286));
        system.debug(query.substring(572));
        system.debug(query.substring(750));
        
        List<Asset> records = Database.query( query );		
        System.debug( records );
        
        return records;
    }
    
     @AuraEnabled
    public static List<Asset> updateSpiffs(String wherestmnt,String addfields,
                                              string orderstmnt,String spiffId,
                                              String limitstmt,Boolean spiffSearch,List<Asset> serials,String SpaId){
                                                  for(Asset a : serials){
                                                      a.Spiff_Request__c = spiffId;
                                                  }
                                                  
                                                  update serials;
                                                  system.debug('update worked ');
                                                  /*
                                                  try{
                                                      serials = getAssetSearch.getSerialNumber(wherestmnt, addfields, orderstmnt, spiffId, limitstmt, spiffSearch,spaId);  
                                                  }catch(Exception e){
                                                      serials = getAssetSearch.getSerialNumber(wherestmnt, addfields, orderstmnt, spiffId, limitstmt, spiffSearch,spaId);
                                                  }
                                                */
     
     return serials;
                                              }
    
}