public class EvalRequest {
    @AuraEnabled
     public static Eval_Request__c getEval(String recid)
    {     
         Eval_Request__c e = [SELECT ID,Missing_Information__c,Missing_Info_Lightnning__c,
                              Opportunity_Name__c,Opportunity_Name_f__c,Name,GovEd_Account_Waive_Agreement__c,
                              Products__c,Expected_Receive_Date__c,Ship_Method__c,Special_Instructions__c,
                              No_Credit_Card_Eval_Agreement__c,Reason_for_No_Credit_Card__c,Product_Name__r.name,Product_Name_2__r.name,
                              Product_Name_3__r.name,Product_Name_4__r.name,Product_Name_5__r.name,Product_Status__c,Quantity__c,
                              Quantity_2__c,Quantity_3__c,Quantity_4__c,Quantity_5__c,Business_Case_Write_Off__c,
                              Trade_Show__c,Trade_Show_Expected_Return_Date__c,Trade_Show_Shipping_Address__c,
                              Trade_Show_Shipping_Phone__c,Opportunity_Name__r.Name,Reason_for_Request__c,Shipping_Contact_Name__r.Name,
                              Billing_Contact_Name__r.name,Billing_Contact_Name__r.Account.Name,Eval_Process_Stage__c
                              FROM Eval_Request__c WHERE Id = :recid limit 1];
         
         return e;
    }
}