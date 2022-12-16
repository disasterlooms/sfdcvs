public class stringQuery {
    @AuraEnabled
   public static String cleanString(String s){  
       
       if(s == null || s == ''){
            s='%%';
        }else{
            s =  '%'+s+'%';
        } 
       s = String.escapeSingleQuotes(s);
       return s;
 }

}