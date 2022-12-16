public class FlowInvokeEncodingUtil {
  @InvocableMethod(callout=true label='Flow Get Base64 String')    
  public static List<String> getBase64String(List<String>apiKeys) {
    
    
    Blob credentialsBlob = Blob.valueOf(apiKeys[0]);
    String Base64String = EncodingUtil.base64Encode(credentialsBlob);
    List<String> Base64Strings = new List<String>();
    Base64Strings.add(Base64String);  
    return Base64Strings;  
  } 
}