public class TriggerContextUtility {
    // Creating an Account Specific first run to ensure account triggers run only once per transaction
    // no matter what object the trigger starts from, the account triggers can run 1 time. 
    private static boolean firstRun = true;
    private static boolean globalTriggers = true;
    private static boolean triggerQueableFirstRun = true;
	
    public static boolean istriggerQueable(){
         return triggerQueableFirstRun;
    }
    public static void settriggerQueableFalse(){
        triggerQueableFirstRun = false;
    }
    public static void settriggerQueableTrue(){
        triggerQueableFirstRun = true;
    }
    
    
    public static boolean isglobalTriggers(){
         return globalTriggers;
    }
     public static void setGlobalTriggersFalse(){
        globalTriggers = false;
    }
    public static void setGlobalTriggersTrue(){
        globalTriggers = true;
    }
    
    public static boolean isFirstRun() {
        return firstRun;
        
    }
    public static void setFirstRunFalse(){
        firstRun = false;
    }

    public static void setFirstRunTrue(){
        firstRun = true;
    }
}