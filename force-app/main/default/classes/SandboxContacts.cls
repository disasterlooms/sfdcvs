public class SandboxContacts {
    public static void addcontacts(){
        StaticResource accts = [Select  Body From StaticResource where Name LIKE 'SandBoxContacts%'];
        blob csvFileBody = accts.Body;
        string csvAsString = '';  
        
        String hex = EncodingUtil.convertToHex(csvFileBody);
        System.assertEquals(0, hex.length() & 1);
        final Integer bytesCount = hex.length() >> 1;
        String[] bytes = new String[bytesCount];
        for(Integer i = 0; i < bytesCount; ++i)
            bytes[i] =  hex.mid(i << 1, 2);
        csvAsString = EncodingUtil.urlDecode('%' + String.join(bytes, '%'), 'ISO-8859-1');        
        String[] csvFileLines = null;
        Account vs = [Select id from account where name like '%Viewsonic%' limit 1];
        
        csvFileLines = csvAsString.split('\n'); 
        system.debug(csvFileLines);
        List<Contact> consToInsert = new List<Contact>();
        for(Integer i=1;i<csvFileLines.size();i++){
            
            Contact accObj = new Contact() ;
            string[] csvRecordData = csvFileLines[i].split(',');
            accObj.LastName =  csvRecordData[0];             
            accObj.email = csvRecordData[1];
            accObj.AccountId = vs.Id;       
            accObj.MailingCity = csvRecordData[3];
            accObj.MailingState = csvRecordData[4];            
            accObj.MailingCountry = csvRecordData[5];                
            consToInsert.add(accObj);
        } 
        
        database.insert(consToInsert,false);
        system.debug(consToInsert);
        system.debug(consToInsert.size());
        
        Set<String> conemails = new Set<String>();
        Map<String,Contact> cons = new Map<String,Contact>();
        for(Contact c : consToInsert){
            cons.put(c.email, c);
            conemails.add(c.email);
        }
        
        List<User> users = [Select id, email, contact_id__c, accountid__c from user where isActive = true and email in: conemails];
        
        
        for(User u : users){
            if(cons.containskey(u.email)){
                Contact c = cons.get(u.email);
                u.Contact_ID__c = c.Id;
                u.AccountId__c = c.AccountId;                
            }
            
            
        }
        update users;
    }
    
}