public class FutureContext {
    // Static variables are local to the context of a Web request  
    // (or testMethod during a runTests call)  
    // Therefore, this variable will be initialized as false  
    // at the beginning of each Web request which accesses it.  

    private static boolean futureRan = false;


    public static boolean futureHasRun() {
        return futureRan;
    }

    // By setting the variable to true, it maintains this  
    // new value throughout the duration of the request  
    // (or testMethod)  
    
    public static void setFutureRan() {
        futureRan = true;
    }
    public static void setFutureRanFalse() {
        futureRan = false;
    }

    public static String getFollowUpSubject(String subject) {
        return 'Follow Up: ' + subject;
    }

}