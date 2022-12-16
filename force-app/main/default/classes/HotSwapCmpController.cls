public class HotSwapCmpController {
        @AuraEnabled
        public static List<QuoteLineItem> getSpaProducts(String recordId){
            list<QuoteLineItem> QuoteLineItemList = [select id,Quantity,Product2.Name,UnitPrice,Approved_Price__c,Hot_Swap_Flag__c,Hotswap_Identification__c from QuoteLineItem where QuoteId =:recordId];
            return QuoteLineItemList; 
        }
        
        
        @AuraEnabled
          public static String getUpdateSpaProducts(String recordId,Hot_Swap__c htswap,list<QuoteLineItem> spaProducts){ // Added "Hot_Swap__c htswap" by Shweta for creating HotSwap Records for  Hotswap project on 27-10-2022
              string status='';
              string skunames = '';
            string prodHotSwap='';
              
            List<String> prodList=new List<String>();
             List<ProcessInstance> swaplist=new List<ProcessInstance>();
              swaplist=[select id,Status,TargetObjectId from ProcessInstance where TargetObjectId =:recordId and Status Not In('Rejected','Approved') ];
                if(swaplist==null || swaplist.isEmpty()){                  
            for(QuoteLineItem e : spaProducts){
                //e.Hot_Swap_Flag__c = true;
                System.debug('e.Product2.Name'+e);
                 e.Hotswap_Identification__c = true;
                skunames = skunames+';'+e.Product2.Name;
                System.debug('Hot Swap'+e.pricebookentryId);
                System.debug('Hot Swap'+e.Product2id);
                if(Test.isRunningTest())
                e.product2 = [select Name,Hot_Swap_Quantity__c,Product_Quantity_Sold__c from product2 where id = :e.Product2id];
                if(e.Product2.Hot_Swap_Quantity__c==null )
                {
                    e.Product2.Hot_Swap_Quantity__c='1';
                    
                }
                
                prodHotSwap=prodHotSwap+''+e.Product2.Hot_Swap_Quantity__c+'/'+e.Product2.Product_Quantity_Sold__c+' - '+e.Product2.Name+'\n'; // Added "Hot_Swap__c htswap" by Shweta for creating HotSwap Records for  Hotswap project on 28-10-2022               
                System.debug('prodHotSwap'+prodHotSwap);
                String prodName=e.Product2.Name;
                prodList.add(prodName );
                System.debug('Prod list'+prodList);
            }
           List<Hot_Swap__c> preHotswapRecordFinal=new List<Hot_Swap__c>();
            List<Hot_Swap__c> preHotswapRecords=new List<Hot_Swap__c>();
                  preHotswapRecords=[select ID ,SPA__c,HotSwap_Final_Status__c,Hot_Swap_Request_Status__c,Hot_Swap_Request_Summary__c from Hot_Swap__c where SPA__c=:recordId];  
                    System.debug('preHotswapRecords'+preHotswapRecords);
                    if(preHotswapRecords!=null || !preHotswapRecords.isEmpty() || preHotswapRecords.size()!=0){
                    for(Hot_Swap__c h:preHotswapRecords){
                        if(h.HotSwap_Final_Status__c!=true){
                            
                            h.HotSwap_Final_Status__c=true;
                        }
                        if(h.Hot_Swap_Request_Status__c=='Approved'){
                            h.Hot_Swap_Request_Summary__c='Approved';
                        }
                        else if(h.Hot_Swap_Request_Status__c=='Rejected'){
                            h.Hot_Swap_Request_Summary__c='Rejected';
                        }
                        preHotswapRecordFinal.add(h);
                        System.debug('preHotswapRecordFinal'+preHotswapRecordFinal);
                    }
                    Database.update(preHotswapRecordFinal);
                    }
            User u = [select id, managerid from user where id =: UserInfo.getUserId()];
            Quote newQuote = new Quote();
            newQuote.ID = recordId;
            newQuote.BR_ManagerId__c = u.ManagerId;
            newQuote.Reason_For_Hotswap__c = htswap.Reason_For_Hot_Swap__c;
            //newQuote.Hot_Swap_Requested__c = true; --- commented on 0729
            newQuote.In_Hot_Swap_Review__c=  true;
            //newQuote.hot_swap_approved_or_rejected__C='Approved'; --- commented on 0729
           //newQuote.Hotswap_Items__c = skunames.substring(1, skunames.length());
           newQuote.Hotswap_Items__c = prodHotSwap;
            newQuote.Hot_Swap_Approved_Or_Rejected__c='Pending For Approval';
                    
            //try{
            system.debug('---spa products identification'+spaProducts);
           
            
            update spaProducts;
            update newQuote;
            //Start: Added by Shweta for creating HotSwap Records for  Hotswap project//
            
                    
            Hot_Swap__c newHotSwap= new Hot_Swap__c();
            newHotSwap.SPA__c=recordId;
            newHotSwap.Recipient_Name__c=htswap.Recipient_Name__c;
            newHotSwap.Recipient_Phone__c=htswap.Recipient_Phone__c;
            newHotSwap.Recipient_Email__c=htswap.Recipient_Email__c;
            newHotSwap.Reason_For_Hot_Swap__c=htswap.Reason_For_Hot_Swap__c;
            newHotSwap.Street__c=htswap.Street__c;
            newHotSwap.State__c=htswap.State__c;
            newHotSwap.PostalCode__c=htswap.PostalCode__c;
            newHotSwap.City__c=htswap.City__c;
            newHotSwap.Country__c=htswap.Country__c;
            newHotSwap.HotSwap_Product_Quantity__c= prodHotSwap;
 			newHotSwap.Hot_Swap_Products_Tracking_Id__c=prodHotSwap;
            newHotSwap.Customer_Service_Action__c='Pending';
            insert newHotSwap;
          /*  List<Product2> prodUpdateList =new List<Product2>();
            List<Product2> getProdList=[Select Hot_Swap_ID__c,Hot_Swap_Quantity__c,Product_ID__c FROM Product2 where Name in : prodList];
            System.debug('Prod List '+getProdList);
            if(getProdList!=null){ 
               for(Product2 p:getProdList){
                   p.Hot_Swap_ID__c=newHotSwap.Id;

                     prodUpdateList.add(p); 
                
            }
               update prodUpdateList;
                 System.debug('prodUpdateList'+prodUpdateList);
                
            }*/
               // }
            
             //End: Added by Shweta for creating HotSwap Records for  Hotswap project//
                //start approval process   
                       Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                        req1.setComments('Submitted for Hot Swap Request Approval');
                        req1.setObjectId(newQuote.id);   // req1.setObjectId(q.OpportunityId__c);
                        
                        // Submit on behalf of a specific submitter
                        //req1.setSubmitterId(unsub.Id); 
                
                        // Submit the record to specific process and skip the criteria evaluation
                        req1.setProcessDefinitionNameOrId('SPA_Hot_Swap_Request');
                        //req1.setSkipEntryCriteria(true);
                        SYSTEM.debug('@@@@@Approval'+req1); 
                
                       Approval.ProcessResult result = Approval.process(req1);
          
            status='Hotswap Record Created';
                }
                else{                    
                     status='No Hotswap Record Created';            
                }

              return status;
        }

    }