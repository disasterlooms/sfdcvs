global without sharing class  ExternalEmailMatch {
    global string searchText {get;set;}
    global string conid {get;set;}
    global string acctid {get;set;}
    global string conname {get;set;}
    global string acctowner {get;set;}
    global string acctowneremail {get;set;}
    global string acctname {get;set;}
    global string mssg {get;set;}
    global boolean flowrender {get;set;}
    global string endusername {get;set;}
    global string enduserstreet {get;set;}
    global string enduserstate {get;set;}
    global string endusercity {get;set;}
    global string enduserzip {get;set;}
    global string distributors {get;set;}
    global string products {get;set;}
    global integer quantity {get;set;}
    global datetime closedate {get;set;}
    
    global ExternalEmailMatch(){
        flowrender= false;
        //con = [SELECT Id, Name, Email FROM contact 
        // WHERE Email = :searchText];
        // system.debug('the contact '+con.id);
        
    }
    
    
    global PageReference submit() {
        //update con;
        List<Contact> con = new List<Contact>();
        system.debug('the sea '+searchText);
        if(searchText == ''){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL  ,'Seriously? Please put a valid email that has been set up.');
            ApexPages.addMessage(myMsg);
        }else{
            
            
            
            con = [SELECT Id, Name, Email,AccountId,Account.name,Account.Owner.Name,Account.Owner.Email FROM contact 
                   WHERE Email = :searchText limit 1];
            system.debug('the contact '+con);
            if(con.size() > 0){
                conid = con[0].Id;
                conname = con[0].name;
                mssg = 'Found your account, If Incorrect, Let Sales Rep know before proceeding. Account Name: ' +con[0].Account.Name;
                acctid = con[0].AccountId;
                flowrender = true;
                acctowner = con[0].Account.Owner.Name;
                acctowneremail=  con[0].Account.Owner.Email;
            }else{
                mssg = 'Could not find your account, Check spelling and white spaces. If correct, please have Sales rep check if this email address is set up.';
            }
        }
        return null;
    }
    global PageReference quote() {
        Opportunity o = new Opportunity();
        o.name = 'Reseller Opp sub';
        o.End_User_Company__c = endusername;
        o.End_User_Street__c = enduserstreet;
        o.End_User_City__c = endusercity;
        o.End_User_State_Text__c = enduserstate;
        o.End_User_Zip__c = enduserzip;
        o.Distributors_Requested__c = distributors;
        o.Product_Quantity__c = quantity;
        o.Products__c = products;
        o.type = 'Project';
        o.StageName = 'Development';
        o.closedate = date.today()+30;
        o.Country__c = 'United States';
        o.RecordTypeId = '012A0000000nzaY';
        o.Channel__c = 'Distribution';
        o.Partner_Account_Search__c = acctid;
        o.ResellerContact__c = conid;
        
        try{
            insert o;
            system.debug(o.Id);
            Opportunity opp = [Select id, name from opportunity where id = : o.Id];
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM ,'Your submission was accepted. Your sales rep, '+acctowner+' will be notified. Their email address is '+acctowneremail+ 
                                                            ' Also, you can give them the End User Name so they can search the deal');
            ApexPages.addMessage(myMsg);
        }catch(Exception e){
            String t = 'Reseller Externalsiteerror'+ o; AdminErrorMessage.SendError(e, t);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Sorry, there was an error. Admin has been notified.');
            ApexPages.addMessage(myMsg);
        }
        flowrender = false;
            searchText = null;
            conid = null;
            acctid = null;
            conname = null;
            acctowner = null;
            acctowneremail = null;
            acctname = null;
            endusername = null;
            enduserstreet = null;
            enduserstate = null;
            endusercity = null;
            enduserzip = null;
            distributors = null;
            products = null;
            quantity = null;
            closedate = null;
        return null;
    }
    
    
}