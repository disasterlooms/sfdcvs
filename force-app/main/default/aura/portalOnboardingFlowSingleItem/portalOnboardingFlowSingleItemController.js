({
	init : function (cmp,event,helper) {
    console.log('running flow');
    var flow = cmp.find("flowData");
    let tsk =   cmp.get("v.taskObj");
        if(tsk.Partner_Portal_Task__r.Action_Type__c == null){
          tsk.Partner_Portal_Task__r.Action_Type__c = '';   
        }
        if(tsk.Partner_Portal_Task__r.Agreement_Text__c == null){
         tsk.Partner_Portal_Task__r.Agreement_Text__c = '';   
        }
         if(tsk.Partner_Portal_Task__r.CompletedTaskURL__c == null){
         tsk.Partner_Portal_Task__r.CompletedTaskURL__c = '';   
        }
        
         if(tsk.Partner_Portal_Task__r.Image_URL__c == null){
         tsk.Partner_Portal_Task__r.Image_URL__c = '';   
        }
        console.log(tsk.Partner_Portal_Task__r.Action_Type__c);
        var inputVariables = [
        {
            name : 'button',
            type : 'String',
            value : tsk.Partner_Portal_Task__r.Button_Name__c
        },
        {
            name : 'description',
            type : 'String',
            value : tsk.Partner_Portal_Task__r.Description__c
        },
        {
            name : 'imageURL',
            type : 'String',
            value : tsk.Partner_Portal_Task__r.Image_URL__c
        },
        {
            name : 'taskName',
            type : 'String',
            value : tsk.Partner_Portal_Task__r.Name
        },
        {
            name : 'taskStatus',
            type : 'String',
            value : tsk.Status__c
        },
        {
            name : 'actionType',
            type : 'String',
            value : tsk.Partner_Portal_Task__r.Action_Type__c
        },
        {
            name : 'AgreementText',
            type : 'String',
            value : tsk.Partner_Portal_Task__r.Agreement_Text__c
        },
        {
            name : 'taskCompletedURL',
            type : 'String',
            value : tsk.Partner_Portal_Task__r.CompletedTaskURL__c
        },
         {
            name : 'taskOnbRecordId',
            type : 'String',
            value : tsk.Id
        }
            
            
        ];
        try{
            flow.startFlow("portalOnboardingTasks", inputVariables);
        }catch(err){
            console.log('error on flow');
            console.log('err message '+err.message);
        } 
    
    }
})