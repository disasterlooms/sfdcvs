trigger ProductMargin on OpportunityLineItem (before update) {
    List<String> oOpportunityLineItemNames = new List<String>{};
        for (OpportunityLineItem op : Trigger.new){
         OpportunityLineItem old = Trigger.oldMap.get(op.ID);
        if (op.MarginText__c == null ) {
        op.MarginText__c = String.valueOf(op.Margin__c);
        } else if(op.Margin__c != null ) {
        op.MarginText__c = String.valueOf(op.Margin__c)+'%';
         }
      } 
   }