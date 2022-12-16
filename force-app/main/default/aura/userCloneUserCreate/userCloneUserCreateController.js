({
    myAction : function(cmp, event, helper) {
        var recid = cmp.get("v.recordId");
        var clUrl = 'https://viewsonic.my.salesforce.com/'+recid+'/e?clone=1&retURL=%2F{!User.Id}&name_firstName=&name_lastName=&Alias=&Email=&Username=&CommunityNickname=&00N1200000BDPIX=&00N1200000BDPYz=&00N1200000BDOyI=&MobilePhone=&Phone=&Addressstreet=&Addresscity=&Addressstate=&Addresszip=';
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": clUrl
        });
        urlEvent.fire();
        alert('new');
        
        /*
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "User"
        });
        createRecordEvent.fire();
        */
        
    }
})