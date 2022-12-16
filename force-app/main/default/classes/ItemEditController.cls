public with sharing class ItemEditController {

  private ApexPages.StandardController controller {get; set;}
  public List<Eval_Unit_Details__c> searchResults {get;set;}
  public string searchText {get;set;}

  // standard controller - could also just use custom controller
  public ItemEditController(ApexPages.StandardController controller) { }

  // fired when the search button is clicked
  public PageReference search() {
    String qry = 'select id, RMA__c, Write_off_Reason__c, Status__c, Name from Eval_Unit_Details__c ' +
      'where RMA__c LIKE \'%'+searchText+'%\' order by RMA__c';
    searchResults = Database.query(qry);
    return null;
  }

  // fired when the save records button is clicked
  public PageReference save() {

    try {
      update searchResults;
    } Catch (DMLException e) {
      ApexPages.addMessages(e);
      return null;
    }

    return new PageReference('/apex/EvalRequestsSearch');
  }

  // takes user back to main record
  public PageReference cancel() {
    return new PageReference('/apex/EvalRequestsSearch');
  }

}