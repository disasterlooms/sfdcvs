trigger ApprovedSpaPrice on OpportunityLineItem (before update) {
    List<String> oOpportunityLineItemNames = new List<String>{};
        for (OpportunityLineItem op : Trigger.new){
         OpportunityLineItem old = Trigger.oldMap.get(op.ID);
        if (op.Approved_Price__c != old.Approved_Price__c) if(op.SPA_Status__c != 'Approved'){       
         op.SPA_Status__c = 'Approved';
         }
    }
}