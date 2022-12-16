public class EvalRequestMaster {
	public static void QuoteRequest(List<Eval_Request__c> evals) {

		//create a list of quotes, eval requests where quotes have been sent out
		//to cross refrence with child records, units that need update

		List <Eval_Request__c> quotes = new List<Eval_Request__c>();
		
		for(Eval_Request__c e : evals){
			if(e.Eval_Quote_Sent_Out__c == true){
				
				e.Eval_Quote_Sent_Out__c = false;
				quotes.add(e);
				
			}
		}

		//create a list to update all the child records, units, that belong to the eval requests in this trigger meeting
		//the condition of having a eval quote sent out

		List <Eval_Unit_Details__c> unitsToUpdate = new List<Eval_Unit_Details__c>();

		//make sure that there are records in the quotes list
		if(quotes.size() < 0){
			return;
		}

			for(Eval_Unit_Details__c u : [Select Id,Quote_Product__c,Eval_Request__c from Eval_Unit_Details__c where Eval_Request__c In: quotes ]){
				u.Quote_Product__c = false;
				unitsToUpdate.add(u);

			}

			try{

				update unitsToUpdate;
			}catch(Exception e){
            String t = 'Eval Units quote reset';
            AdminErrorMessage.SendError(e,t);

			}
					
	}
}