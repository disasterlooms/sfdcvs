({
    handleTicketchange : function(cmp,event,helper){
        console.log('lighting message received');
    },
    fdTicketSelection : function(cmp, event, helper) {
        var params = event.getParams();
        var payload = params.payload;
        // console.log('payload');
        if(payload){
            var step = payload.step;
            // console.log('step');
            // console.log(step);
            var dataArray = payload.data;
            //console.log('data');
            console.log('data array 2');
            console.log(dataArray[0]);
            console.log(dataArray);
            var data = dataArray[0];
            if(data){
                console.log('data 2');
                console.log(data);
                console.log(data[0]);
                                
                var ticket = data['ticketId'];
                if(ticket){
                    console.log('ticketid');
                    console.log(ticket);
                    cmp.set("v.fdTicketId",ticket);
                    var spinner = cmp.find("mySpinner");
                    helper.showSpinner(cmp,event,helper);
                    helper.getTicketDetails(cmp,event,helper);


                }
                /*
                if(spaid.length <1 ){
                    cmp.set("v.recordId",spaid);   
                }
                */
                             
                
            }
        }

    }
})