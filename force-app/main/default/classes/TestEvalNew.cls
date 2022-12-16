@isTest
private class TestEvalNew {
@testSetup
    private static void BuildTestData(){
        BuildTestData.AddRecords();
    }
static testmethod void getUser()  
  {
      //passed 10.27 
      //
      test.startTest();
      Eval_request__c eval = [Select id,Product_Name__c  from eval_request__c limit 1];
      List<Eval_unit_details__c> units = new  List<Eval_unit_details__c>();
	  Eval_unit_details__c u = new Eval_unit_details__c();
      u.Eval_request__c = eval.Id;
      u.name = '123123434';
      u.Transfer_Requested__c = true;
      u.SKU__c = eval.Product_Name__c;
      units.add(u);
      
      Eval_unit_details__c u1 = new Eval_unit_details__c();
      u1.Eval_request__c = eval.Id;
      u1.name = '12312343422';
      u1.Transfer_Requested__c = true;
      u1.SKU__c = eval.Product_Name__c;
      units.add(u1);
      
      
      insert units;
      
      Eval_request__c evalCheck = [Select id,Product_Name__c,
                              (select id from eval_unit_details__r)  from eval_request__c where id =:  eval.Id];
      for(Eval_unit_details__c ev : evalCheck.eval_unit_details__r){
		ev.Transfer_Requested__c = true;
      }
      
      List<Eval_unit_details__c> unitsUpdate = new  List<Eval_unit_details__c>(evalCheck.eval_unit_details__r);
      update unitsUpdate;
      
      system.debug('eval check size of data ');
      system.debug(evalCheck);
      system.debug(evalCheck.eval_unit_details__r.size());
      system.debug(evalCheck.eval_unit_details__r);
      NewEval.getEval(eval.Id);
      NewEval.getUser();       
      Boolean trade = false;
      NewEval.getTypes(trade);
      trade = true;
      NewEval.getTypes(trade);
     
       
      test.stopTest();
  }

}