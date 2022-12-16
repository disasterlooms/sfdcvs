trigger Update_Email_on_Eval_Detail on Eval_Unit_Details__c (before insert)
{
    //  loop through the records in the trigger to build a set of related Eval Request IDs
    //Set<Id> set_EvalRequestIDs = new Set<Id>();
    //Set<Id> set_EvalEmail = new Set<Id>();
    
   // for ( Eval_Unit_Details__c detail : trigger.new )  {
    //    if ( detail.Eval_Request__c != null ) 
      //      set_EvalRequestIDs.add( detail.Eval_Request__c );
        //    set_EvalEmail.add( detail.Eval_Submitter_Email__c);
    //}
    
    //  query the Eval Requests and put the results into a Map
    //Map<Id,Eval_Request__c> map_EvalRequests = new Map<Id,Eval_Request__c>
    //(   [   SELECT  Id, Shipping_Contact_Email__c, Eval_Submitter_Email__c
    //        FROM    Eval_Request__c
     //       WHERE   Id IN :set_EvalRequestIDs
     //   ]
   // );
    
    //  loop through the records in the trigger again to modify the email addresses
   // for ( Eval_Unit_Details__c detail : trigger.new ) {
   //     if ( detail.Eval_Request__c == null ) continue;        
    //    detail.Shipping_Contact_Email__c = map_EvalRequests.get( detail.Eval_Request__c ).Shipping_Contact_Email__c;
   //     detail.Eval_Submitter_Email__c = map_EvalRequests.get(detail.Eval_Request__c).Eval_Submitter_Email__c;
  //  }
}