global class lookUpAccountAnnotation {
   @InvocableMethod
   public static void getAccountIds(List<String> ids) {
       System.debug(ids);
       System.debug(ids[0]);
   }
}