({
    helperMethod : function() {
        
    },
    showSpinner: function (cmp, event,handler) {
        var spinner = cmp.set("v.toggleClass","");
    },
    hideSpinner: function (cmp, event,handler) {
        var spinner = cmp.set("v.toggleClass","slds-hide");
    },
    schoolMap : function(cmp,event,helper){
        
        var act = cmp.get("v.schools");
        var i;
        console.log('acct school map ');
        console.log(act);
        //console.log(act[0].BillingState);
        var marks =[];
        
        for(i = 0; i < act.length; i++){
            if(i <9){
                
                
                marks.push 
                ({
                    location: {
                        Street: act[i].Street__c ,
                        City: act[i].City__c ,
                        State:  act[i].State__c,
                        Zip:  act[i].Zip__c,
                        Latitude: act[i].latitude__c ,
                        Longitude : act[i].longitude__c 
                    },
                    
                    title: act[i].Name,
                    description: 'School Data '
                });
            }
        }
        console.log(marks);
        console.log('marks');
        console.log('size of schools');
        console.log(marks.length);
        cmp.set('v.mapMarkers',marks);
        
        if(marks.length> 0){
            cmp.set('v.center', {
                location: {
                    City: act[0].City__c ,
                    State:  act[0].State__c 
                }
            }); 
        }
        
        
        
        cmp.set('v.zoomLevel', 12);
        cmp.set('v.markersTitle', 'Schools for Districts Selected');
        cmp.set('v.showFooter', true);
        helper.hideSpinner(cmp,event,helper);
        
    },
    getMaps: function (cmp, event, helper) {        
        helper.showSpinner(cmp,event,helper);
        console.log('spinner');
        var accts  ;
        var action = cmp.get("c.getaccts");
        action.setParams({"city": cmp.get("v.city"),
                          "county" : cmp.get("v.county"),
                          "state" : cmp.get("v.state"),
                          "zip" : cmp.get("v.zip"),
                          "ind" : 'Education',
                          "acctType" : 'End User',
                          "classSize" : null,
                          "rev" : null,
                          "rank" : null,
                          "limitstmnt" : 'limit ' +cmp.get("v.limitstmnt"),
                          "wherestmnt" : " and District_Classroom_Count__c > 5  ",
                          "orderstmnt" : "order by District_Classroom_Count__c  desc",
                          "focus" : false
                         });
        
        
        action.setCallback(this, function(data) {         
            var rslt = data.getState();
            if (rslt === "SUCCESS"){
                var dt = data.getReturnValue();
                console.log(dt);
                cmp.set("v.accts",dt);            
                
                if(dt.length>0){
                    helper.setMap(cmp,event,helper);
                    console.log(' accts yes');
                }else{
                    helper.hideSpinner(cmp,event,helper);
                    console.log('no accts');
                }
                
            }else{
                helper.hideSpinner(cmp,event,helper);
                console.log('there was an error please notify admin');
            }
        });
        
        $A.enqueueAction(action);
        
        //console.log('accts '+ accts[0].BillingLongitude);
        
    },
    setMap : function(cmp,event,helper){
        
        var act = cmp.get("v.accts");
        var i;
        console.log('acct ');
        console.log(act);
        var marks =[];
        
        for(i = 0; i < act.length; i++){
            
            marks.push 
            ({
                location: {
                    Street : act[i].BillingStreet,
                    City : act[i].BillingCity,
                    State : act[i].BillingState,
                    Phone : act[i].Phone,
                    Latitude: act[i].BillingLatitude,
                    Longitude: act[i].BillingLongitude,
                    
                },
                
                title: act[i].Name,
                description: 'Phone '+act[i].BillingAddress
            });
        }
        console.log(marks);
        console.log('marks');
        cmp.set('v.mapMarkers',marks);
        cmp.set('v.center', {
            location: {
                Latitude: act[0].BillingLatitude,
                Longitude: act[0].BillingLongitude
            }
        });
        
        cmp.set('v.zoomLevel', 11);
        cmp.set('v.markersTitle', 'School Districts');
        cmp.set('v.showFooter', true);
        helper.hideSpinner(cmp,event,helper);
    }
})