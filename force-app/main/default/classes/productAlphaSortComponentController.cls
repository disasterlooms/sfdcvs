public class productAlphaSortComponentController {
    
  public String controllerValue;
  public List<QuoteLineItem> lineItems {get;set;}
    
  public void setControllerValue (String s) {
      controllerValue = s;
      lineItems = [select Product2.Name, Quote.Opportunity.Country__c, Max_Qty__c, ListPrice, Quantity, Approved_Price__c, SPA_Approval_Date__c, SPA_Expiration_Date__c, Product2.Description from QuoteLineItem where QuoteId=:s order by Product2.Name asc];
  }
    
  public String getControllerValue() {
      return controllerValue;
  } 

}