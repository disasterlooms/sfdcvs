public class EvalContact {
    Eval_Request__c eval {get;set;}
    Opportunity opp{get;set;}

    //constructor for extension
    public EvalContact(ApexPages.StandardController stdController){
        eval = (Eval_Request__c)stdController.getRecord();
        List<Opportunity> opps = [SELECT ID,Name FROM Opportunity WHERE Name = 'Viewsonic Sales Rep Evaluations' LIMIT 1];
        List<Opportunity> opps1 = [SELECT ID,Name FROM Opportunity WHERE Name = 'Viewsonic Trade Show Loaner Eval Requests' LIMIT 1];
    
        User current_user=[SELECT Contact_ID__c,Id,Name FROM User WHERE Id= :UserInfo.getUserId()] ;
        
        if(eval.Eval_Type__c == 'ViewSonic Sales Rep Eval' && eval.Opportunity_Name__c == null && eval.Trade_Show__c == false && opps.size() >0){
        eval.Opportunity_Name__c = opps[0].Id;
        }
        if(eval.Trade_Show__c == True && eval.Opportunity_Name__c == null && opps1.size() >0){
        eval.Opportunity_Name__c = opps1[0].Id;
        }
        // set up the owner of the record to be the Contact that is linked to the user. 
       
       eval.Evaluation_Owner__c = current_user.Contact_ID__c;
       //get contact id and all related past due and outstanding roll up summaries to determine if okay to proceed or to lock out of eval creation
       //Contact cont = [Select PR_Outstanding_Evals_EU_Disty__c,PR_Past_Due_Evals__c,PR_Write_offs_Last_12_Months__c FROM Contact Where Id= :current_user.Contact_ID__c LIMIT 1];
       //eval.Total_Past_Due_Evals__c = cont.Past_Due__c;
       //eval.Evals_Outstanding_Contact__c = cont.PR_Outstanding_Evals_EU_Disty__c; 
       //eval.Evals_Past_Due_Contact__c = cont.PR_Past_Due_Evals__c;
       //pull the opportunity line items that were created and linked to this eval. Must use button on opportunity page to pull the data from opportunity
       List<OpportunityLineItem> prod = [SELECT ID,ProductCode,Quantity,Product2Id,Evaluation_Product__c FROM OpportunityLineItem WHERE Evaluation_Product__c = True AND OpportunityId = :ApexPages.currentPage().getParameters().get('CF00NA000000AJjZv_lkid')];
         // If opportunity products exists, then pull the id otherwise do not depending on the size of the list, different skus will be pulled
     if(prod.size() > 4) {
        eval.Product_Name__c = prod[0].Product2Id;
        eval.Quantity__c = 1;
        
        eval.Product_Name_2__c = prod[1].Product2Id;
        eval.Quantity_2__c = 1;
        
        eval.Product_Name_3__c = prod[2].Product2Id;
        eval.Quantity_3__c = 1;
        
        eval.Product_Name_4__c = prod[3].Product2Id;
        eval.Quantity_4__c = 1;
        
        eval.Product_Name_5__c = prod[4].Product2Id;
        eval.Quantity_5__c = 1;
        
}  

else if(prod.size() == 4) {
    
    eval.Evaluation_Owner__c = current_user.Contact_ID__c;
        eval.Product_Name__c = prod[0].Product2Id;
        eval.Quantity__c = 1;
        
        eval.Product_Name_2__c = prod[1].Product2Id;
        eval.Quantity_2__c = 1;
        
        eval.Product_Name_3__c = prod[2].Product2Id;
        eval.Quantity_3__c = 1;
        
        eval.Product_Name_4__c = prod[3].Product2Id;
        eval.Quantity_4__c = 1;
}  
else if(prod.size() == 3) {
    
    eval.Evaluation_Owner__c = current_user.Contact_ID__c;
        eval.Product_Name__c = prod[0].Product2Id;
        eval.Quantity__c = 1;
        
        eval.Product_Name_2__c = prod[1].Product2Id;
        eval.Quantity_2__c = 1;
        
        eval.Product_Name_3__c = prod[2].Product2Id;
        eval.Quantity_3__c = 1;
        
        
}   
else if(prod.size() == 2) {
    
    eval.Evaluation_Owner__c = current_user.Contact_ID__c;
        eval.Product_Name__c = prod[0].Product2Id;
        eval.Quantity__c = 1;
        
        eval.Product_Name_2__c = prod[1].Product2Id;
        eval.Quantity_2__c = 1;
       
        
        
} 
else if(prod.size() == 1) {
    
    eval.Evaluation_Owner__c = current_user.Contact_ID__c;
        eval.Product_Name__c = prod[0].Product2Id;
        eval.Quantity__c = 1;
        
} 



eval.Evaluation_Owner__c = current_user.Contact_ID__c;

    }
}