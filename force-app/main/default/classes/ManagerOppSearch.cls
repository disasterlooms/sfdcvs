public class ManagerOppSearch {
    //set the query paramaters to be used by different methods in this controller
    //only updating the pos line items, update not used for opportunities
    public List<Opportunity> opps {get;set;}
    public List<Opportunity> datepicker =new List<Opportunity>();
    
    //the variables below are for mathching opportunities. Originally created for POS
    //matching, it became useful for other applications. Instead of separating the class
    //the classes will be used for either POS search, opp sear, opp updates.
    
    public String oppowner {get;set;}    
    Public Date oppcreatedatefrom {set;get;}
    Public Date oppclosedateto {get;set;}
	    
 
    public PageReference getopps()
    {
        //query all opportunities based on filtered criteria
        //first run query on the opp line items based on any criteria given
        
	  Date create = oppcreatedatefrom;
      Date close = oppclosedateto;
      String owner = oppowner; 
        //following code is for test method to pull running user as owner
        if(owner == null){
            User u = [Select name from user where id =: UserInfo.getUserId() Limit 1];
            owner = u.Name;
        }
        if(create == null){
            create = Date.today()-720;
        }
        if(close == null){
            close = Date.today()+720;
        }

        opps =                 [Select id, Spa_ID__c, Name, Resellers_and_Type__c,Account.Name, (SELECT Product2Id FROM OpportunityLineItems),
                                End_User_City__c , Opportunity_Notes__c,
                               CreatedDate, CloseDate,StageName,OwnerId,Owner.LastName,Amount,
                               Manager_Note__c,Project_or_Site_Information__c,Bid_Registered__c,
                               Owner.Name from Opportunity
                               Where Owner.Name Like :owner AND Day_Only(CreatedDate) > : create
                               And CloseDate < : close AND StageName != 'Closed Won' And StageName != 'Closed Lost' And Type != 'Master Spa'
                               Limit 50];       
        
        system.debug('list of opps : '+ opps.size());
        system.debug('owner : '+ owner);
        system.debug('close : '+ close);
        system.debug('create : '+ create);
        return null;
        
    }
    public PageReference updateopps(){  
       //save the opportunities after update or send error message to admin
     
       String  errormessages = '';
       Integer numerrors = 0;
       Integer numsuccess = 0;
       String message ='';
       system.debug('opps updating: '+opps.size());
        List<Database.SaveResult> updateResults = Database.update(opps, false);
                for(Integer i=0;i<updateResults.size();i++){
                    if (updateResults.get(i).isSuccess()){
                        updateResults.get(i).getId();
                        system.debug('success id '+ opps.get(i).Name);
                        numsuccess += 1;
                
                    }else if (!updateResults.get(i).isSuccess()){
                        // DML operation failed
                        Database.Error error = updateResults.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        opps.get(i);//failed record from the list
                        system.debug('Failed ID '+opps.get(i).Name); 
                        system.debug('Message '+ failedDML);
                        errormessages += 'Name: '+opps.get(i).Name+'<br/>'+'Error: '+ failedDML+ '<br/><br/>';
                        numerrors += 1;
                        
                     }
                
                }
        
        system.debug('number of errors '+numerrors+ ' successes '+numsuccess);
        //Relay the number of successes
        if(numsuccess > 0){
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,numsuccess+ ' record(s) were successfully saved'));
        }
        
        //Get the number of errors, if more than one then show the error message
        if(numerrors > 0){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There were '+numerrors+' errors.Below are the records and'+
      		' reason(s) for error '+'<br/><br/>'+errormessages ));            
        }
        
       return null;
 }   
   
    public List<Opportunity> getdatepicker()
    {
       //this list is set so we can get a date field in the visualforce page. 
       //without a date field, salesforce does not load the date picker javascript
       //and user will not be able to pick the date unless the javascript is  created from scratch
       //this dev will not do that, just found this workaround to add a hidden field and let salesforce
       //do the heavy lifting. Future devs are more than welcome to create. 
       
          datepicker = [SELECT Id,CloseDate  from Opportunity
                  where CloseDate != null Limit 1];
        return datepicker;
    }
  public PageReference clearmessages()
    {
		ApexPages.getMessages().clear();
        return null;
    }

}