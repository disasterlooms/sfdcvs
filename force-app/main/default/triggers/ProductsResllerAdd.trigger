trigger ProductsResllerAdd on Opportunity (before update) {
//List<String> opportunityNames = new List<String>{};
//for (Opportunity o : Trigger.new){
//     Opportunity old = Trigger.oldMap.get(o.ID);
//   if (o.SPA_Products__c > old.SPA_Products__c) if(o.Spa_Stage__c == 'Approved'){
//         o.Spa_Resubmission_Note__c = 'Products Added';
 //        o.Name = old.Name;
  //    }   if (o.SPA_Resellers__c > old.SPA_Resellers__c)if(o.Spa_Stage__c == 'Approved'){
  //       o.Spa_Resubmission_Note__c = 'Resellers Added';
 //        }   if (o.SPA_Products__c > old.SPA_Products__c)if(o.Spa_Stage__c == 'Resubmitted Approved'){
 //        o.Spa_Resubmission_Note__c = 'Products Added';
 //        }   if (o.SPA_Resellers__c > old.SPA_Resellers__c)if(o.Spa_Stage__c == 'Resubmitted Approved'){
 //        o.Spa_Resubmission_Note__c = 'Resellers Added';   
  //  } 
 //  }
 //commenting out trigger in case there is a use for it later. 
}