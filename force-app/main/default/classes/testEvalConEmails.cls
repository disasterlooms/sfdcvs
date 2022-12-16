@IsTest
public class testEvalConEmails  {
    Static testmethod void runConEmails() {
        EvalManagerConEmail evalman = 
                    new EvalManagerConEmail();
        evalman.getevals();
        
        EvalConEmail eval = 
                    new EvalConEmail();
        eval.getevals();
        
        
    }
}