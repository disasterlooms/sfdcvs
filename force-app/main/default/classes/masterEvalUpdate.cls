public class masterEvalUpdate {
    
    Map<Id, Eval_Request__c> oldEvals;
    Map<Id, Eval_Request__c> newEvals;
    
    public masterEvalUpdate(
        Map<Id, Eval_Request__c> oldTriggerEvals,
        Map<Id, Eval_Request__c> newTriggerEvals) {
            oldEvals = oldTriggerEvals;
            newEvals = newTriggerEvals;
        }
    public  void closed()
    {
        for(Eval_Request__c e : newEvals.values()){
            if(e.Product_Status__c == 'Closed' && e.Eval_Process_Stage__c != 'Closed'){
                e.Eval_Process_Stage__c = 'Closed';
            }else if(e.Product_Status__c != 'Closed' && e.Eval_Process_Stage__c == 'Closed'){
                e.Eval_Process_Stage__c = 'Shipped';
            }
        }
        
    }
    public static  void specialApproval(List<Eval_Request__c> evalreq)
    {
        //List<Product2> prods = [Select id,Eval_Special_Approval__c from product2 where  Eval_Special_Approval__c = true];
        
        List<Eval_Request__c> evals = [Select id,Product_Name__r.Eval_Special_Approval__c ,Product_Name_2__r.Eval_Special_Approval__c  ,Product_Name_3__r.Eval_Special_Approval__c
                                       ,Product_Name_4__r.Eval_Special_Approval__c ,Product_Name_5__r.Eval_Special_Approval__c, Large_Format_Request__c  
                                      from Eval_Request__c where id in: evalreq];
        
        for(Eval_Request__c e : evals){
          if(e.Product_Name__r.Eval_Special_Approval__c == true || e.Product_Name_2__r.Eval_Special_Approval__c == true || e.Product_Name_3__r.Eval_Special_Approval__c == true
             || e.Product_Name_4__r.Eval_Special_Approval__c == true || e.Product_Name_5__r.Eval_Special_Approval__c == true ){
                e.Large_Format_Request__c  = true; 
             }else{
                 e.Large_Format_Request__c  = false; 
             }
        }
        
    }
}