public class encryptRecordId {
    public String acctOwnerAssign(String recId) {
        String encryptValue = ''; 
        CustomerKeys__mdt k = [SELECT key__c  FROM CustomerKeys__mdt  limit 1];
        Blob data = Blob.valueOf(recId);
        Blob key = Blob.valueOf(k.key__c);        
        system.debug(k.key__c);
        Blob encryptedData = Crypto.encryptWithManagedIV('AES128',key, data);
        String b64 = EncodingUtil.base64Encode(encryptedData);
        system.debug(' encoded for url '+b64); 
        b64 = EncodingUtil.urlEncode(b64, 'UTF-8');
        return b64;
        
        
    }

}