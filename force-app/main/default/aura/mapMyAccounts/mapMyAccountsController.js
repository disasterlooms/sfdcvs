({
    myAction : function(cmp, event, helper) {
        
    },
    eaChange : function (cmp,event,helper){
        console.log('eachange');
        var params = event.getParams();
        var payload = params.payload;
        if(payload){
            var step = payload.step;
            var dataArray = payload.data;
            console.log('step');
            console.log(step);
            var data = dataArray;
            if(data && data.length > 0 && step == 'DistrictNamesforScho_1'){
                
                var state = data[0]['BillingState'];
                var county = data[0]['County__c'];
                var industry = data[0]['Industry'];
                var district = data[0]['Id'];
                if(district){
                    var dists =[];
                    var i;
                    for(i = 0; i < data.length; i++){
                        dists.push 
                        ({
                            Id :  data[i]['Id']
                        });
                    }
                    
                    cmp.set("v.districtSchls",dists );
                    console.log('schools');
                    console.log(dists);
                    if(dists && step == 'DistrictNamesforScho_1'){
                        
                        var scaction = cmp.get("c.getSchoolssMap");
                        scaction.setParams({
                            "acctIds": dists
                        });
                        scaction.setCallback(this, function(response) {
                            var state = response.getState();
                            if (cmp.isValid() && state === "SUCCESS") {
                                console.log('got schools');
                                var dta = response.getReturnValue();
                                cmp.set("v.schools",dta);
                                console.log(dta);
                                helper.schoolMap(cmp,event,helper);
                            }else{
                              console.log('error schools');
                              let errors = response.getError();
                              var message = errors[0].message;
                               console.log(message);
  

                            }
                        });
                        $A.enqueueAction(scaction);
                    }
                }
            }
            if(data && data.length > 0 && (step == 'County__c_1' ||
                                           step == 'StateCountyMap')){
                cmp.set("v.county", data[0]['County__c']);
                helper.getMaps(cmp,event,helper);
                
            }
        }
    },
    mapSearch : function(cmp,event,helper){
     helper.getMaps(cmp,event,helper);   
    },
    setMaps : function(cmp,event,helper){
        cmp.set('v.mapMarkers', [
            {
                location: {
                    Latitude: '33.926788',
                    Longitude: '-117.87621'
                },
                
                icon: 'utility:salesforce1',
                title: 'ViewSonic Brea',
                description: 'ViewSonic'
            },
            
        ]);
            
            cmp.set('v.center', {
            location: {
            City: 'Brea'
            }
            });
            
            cmp.set('v.zoomLevel', 10);
            cmp.set('v.markersTitle', 'ViewSonic HQ');
            cmp.set('v.showFooter', true);
            }
            })