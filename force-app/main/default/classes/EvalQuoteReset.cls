public class EvalQuoteReset {
    //Apex properties or variables

    public Id Id { get; set; }
    public Eval_Request__c eval { get; set; }

    //constructor to get the Case record
    public EvalQuoteReset(ApexPages.StandardController controller) {
    eval =  (Eval_Request__c) controller.getRecord();
    Id = eval.Id;
    System.debug('The eval record: ' + eval);
    }

    //Method that can is called from the Visual Force page action attribute
     //@InvocableMethod(label='Update Teams' description='Updates Opportunity Team Members')
    
    public PageReference reset() {
        System.debug('eval Id: ' + Id);
        List<Eval_Unit_Details__c> unitsToUpdate = new List<Eval_Unit_Details__c>();
        List<Eval_Unit_Details__c> evals;
          evals = [SELECT Id,Eval_Request__c, 	Quote_Product__c from Eval_Unit_Details__c
                    WHERE Eval_Request__c =: eval.Id];

          for(Eval_Unit_Details__c e : evals){
          	e.Quote_Product__c = false;
          	unitsToUpdate.add(e);

          }

         	update unitsToUpdate;
            
            //PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
            return null; 

          }
    }