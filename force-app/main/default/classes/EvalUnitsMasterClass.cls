public without sharing class EvalUnitsMasterClass {
    Map<Id,Eval_Unit_Details__c> oldUnits;
    Map<Id,Eval_Unit_Details__c> newUnits;
    
    public EvalUnitsMasterClass(Map<Id,Eval_Unit_Details__c> oldtriggerunits, Map<Id,Eval_Unit_Details__c> newtriggerunits){
        oldUnits = oldtriggerunits;
        newUnits = newtriggerunits;
        
    }
    
    public static void productSearch(List<Eval_Unit_Details__c> records){
        
        Map<String, Product2> prods = New Map<String,Product2>();
        for(Product2 p : [Select id,name from product2 where isactive = true]){
            prods.put(p.name, p);
        }
        
        for(Eval_Unit_Details__c e : records){
            if(e.Sku_Text__c != null){
                if(prods.containsKey(e.Sku_Text__c.substringBeforeLast('-'))){
                    product2 p = prods.get(e.Sku_Text__c.substringBeforeLast('-'));
                    e.SKU__c = p.Id;
                }else if(prods.containsKey(e.Sku_Text__c.substringBefore('-'))){
                    product2 p = prods.get(e.Sku_Text__c.substringBefore('-'));
                    system.debug(e.SKU__c);
                    e.SKU__c = p.Id;
                    system.debug(e.SKU__c);
                }   
                
            }
            
            
        }
    }
    
    
    public static void updateunits(List<Eval_Unit_Details__c> units){
        
        for(Eval_Unit_Details__c u : units){
            if(u.Status__c != null && u.Status_Date_Change__c == null){
                u.Status_Date_Change__c = Date.today();
            }
            if(u.Status__c == 'Write-off' && u.Write_Off_Date__c == null){
                u.Write_Off_Date__c = Date.today();
            }            
        }        
    }
    public void invoiced(){
        
        Set<Id> quotes = new Set<Id>();
        
        for(Eval_Unit_Details__c neweu : newUnits.values()){
           Eval_Unit_Details__c oldeu = oldUnits.get(neweu.Id);
            if(neweu.Status__c != oldeu.Status__c && neweu.Status__c.toLowerCase().contains('purchased')  && neweu.Eval_Quote__c != null){
                quotes.add(neweu.Eval_Quote__c);             
                
            }
        }
        List<Eval_Quote__c> quotesToUpdate = new List<Eval_Quote__c>();
        for(Id q : quotes){
           Eval_Quote__c eq = new Eval_Quote__c(id = q,Eval_Quote_Status__c ='Closed');
            quotesToUpdate.add(eq);
        }
        update quotesToUpdate;
    }
    public void closed(){
       //checking to see if eval is closed. then check other units to see if the entire order should be closed.
       //
        Set<Id> evals = new Set<Id>();
        for(Eval_Unit_Details__c neweu : newUnits.values()){
           
            Eval_Unit_Details__c oldeu = oldUnits.get(neweu.Id);
            if(neweu.Status__c != oldeu.Status__c){
                evals.add(neweu.eval_request__c);                
            }
        }
        EvalUnitsMasterClass.evalstatus(evals);
    }
    @future
    public static void evalstatus(Set<Id> records) {
        // review the evals and all their units to see if the order should be closed or not. 
         List <Eval_request__c> evalstoupdate = new List <Eval_request__c>();
         List <Eval_request__c> units = [Select id,Eval_Process_Stage__c,product_status__c ,(Select status__c from Eval_Unit_Details__r)  from Eval_request__c  where id in : records];
         
         for(Eval_request__c e : units){
         Boolean closed = true;
             for(Eval_Unit_Details__c u : e.Eval_Unit_Details__r){
                 if(u.Status__c == null || u.Status__c == '' || u.Status__c == 'Outstanding'){
                     closed = false;
                 }
             }
             if(closed == true){
                 e.Eval_Process_Stage__c = 'Closed';
                 e.product_status__c = 'Closed';
             }else{
                 e.Eval_Process_Stage__c = 'Shipped';
                 e.product_status__c = 'Past Due';
             }
             evalstoupdate.add(e);
             system.debug('status' +e.Eval_Process_Stage__c);
             system.debug('true of false' +closed);
        }
        try{
            update evalstoupdate;
        }catch(exception e){
            system.debug('error '+e);
        }
        
        system.debug(evalstoupdate);
        
        
    }
}