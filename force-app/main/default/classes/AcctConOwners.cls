public class AcctConOwners{
    //Apex properties or variables

    public Id Id { get; set; }
    public Contact con { get; set; }

    //constructor to get the Case record
    public AcctConOwners(ApexPages.StandardController controller) {
    con =  (Contact) controller.getRecord();
    Id = con.Id;
    System.debug('The case record: ' + con);
    }

    //Method that can is called from the Visual Force page action attribute
     //@InvocableMethod(label='Update Teams' description='Updates Opportunity Team Members')
    
    public PageReference updateowners() {
        
       PageReference pageRef = new PageReference('/'+Id);
        pageRef.setRedirect(true);
       return pageRef; //Returns to the opp page
    }
}