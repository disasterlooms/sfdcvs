global class EvalQuoteFlow {
    @InvocableMethod
    public static void getRates(List<String> quoteids) {
        //get eval quote info first and use the city and state to get the tax rate if applicable
        //mapping the quote so it can be used in the loop of eval units
        
        List<Eval_Quote__c> quotes = [Select id,Tax_Rate__c,Shipping_City__c,Shipping_State__c 
                                      from Eval_Quote__c where id in: 
                                      quoteids];
        
        
        List<Eval_Unit_Details__c> units = [Select id from Eval_Unit_Details__c where Eval_Quote__c =: quoteids ];
        
        String quoteid = quotes[0].Id;
        String city ='';
        String state = '';
        
        Map<String, Pricebookentry> pblow = new Map<String, Pricebookentry>();
        for(Pricebookentry pbe : [Select Id, UnitPrice,product2.name from PricebookEntry 
                                  where pricebook2.name ='VSA Product Request Bottom Purchase Price List'])
            pblow.put(pbe.product2.Name, pbe);
        
        system.debug('quote');
        system.debug(quotes);
        if(quotes.size() >0){
            city = quotes[0].Shipping_City__c;
            state = quotes[0].Shipping_State__c;
            
            Map<Id, Eval_Quote__c> quote = new Map<Id,Eval_Quote__c>(quotes);
            
            List<Sales_Tax__c> rate = [Select id, City__c, State_Province__c , Total_Tax_Rate__c from Sales_Tax__c 
                                       where State_Province__c = : state and City__c =: city];
            
            //validating city and state if not, will send email to admin. may need to stop the process later but for now
            //will monitor it becasue the shiping city and state is done through the system not by user most of the time.
             Map<String, County__c > cities = new Map<String, County__c >();
            
            try{
                for(County__c c : [Select id, City__c , Statecode__c from County__c where Statecode__c = : state.toUpperCase()]){
                cities.put(string.valueOf(c.City__c).toLowerCase()+string.valueOf(c.Statecode__c).toLowerCase(), c);
                }
                
            }catch(Exception e){
                
            }
           
            
            if(!cities.containsKey(city.toLowerCase()+state.toLowerCase())){
                system.debug('there is a misspelling');
                CalloutException e = new CalloutException();
                e.setMessage('Eval quote has an invalid city and state');                
                String t = 'Eval quote may have an invalid city and state. The state: '+state+' city: '+ city+' Eval quote : '+quotes;
                AdminErrorMessage.SendError(e, t);
            }
                
            
            List<Eval_Unit_Details__c> details = [Select id,Tax_Rate__c ,Name,Eval_Price_Low__c ,Recycle_Fee__c ,sku__r.Name,Sku_Text__c,Sku_Alt_Name__c ,  Eval_Quote__c,Eval_Quote__r.Shipping_State__c
                                                  from Eval_Unit_Details__c  where id in: units];
            //need to map the recycle fees by product because each product may have a separte fee
            //the map puts the sku as the unique id and then compares each eval unit sku
            //if there is a fee, than the fee is added
            //otherwise the fee will be 0 this is added to each line that is being quoted
            //
            Map<String,Recycle_Fee__c> fees = new Map<String,Recycle_Fee__c>();
            
            for(Recycle_Fee__c rf : [Select Id ,Product__c,Product__r.name ,Recycle_Fee__c from Recycle_Fee__c where Country__c = 'US'])
                fees.put(rf.Product__r.name , rf);
            
            system.debug(fees);
            
            String prods = '';            
            for(Eval_Unit_Details__c e : details){
                system.debug(e.sku__r.name);
                system.debug('sku name');                    
                if(rate.size()>0){
                    e.Tax_Rate__c = rate[0].Total_Tax_Rate__c;
                    quotes[0].Tax_Rate__c = rate[0].Total_Tax_Rate__c;
                }
                
                if(pblow.containsKey(e.sku__r.name)){
                    Double price = pblow.get(e.sku__r.name).UnitPrice;
                    e.Eval_Price_Low__c  = price;                        
                    prods = prods+'SKU: '+ e.sku__r.name+' Price: '+price+' SN: '+e.Name+' \n';
                }
                if(fees.containsKey(e.sku__r.Name)){
                    e.Recycle_Fee__c = fees.get(e.sku__r.Name).Recycle_Fee__c;
                }else{
                    e.Recycle_Fee__c = 0;
                } 
            }
            quotes[0].Products__c = prods;
            update details;
            update quotes[0];
            system.debug(details);
            system.debug(quotes[0]); 
        }
        
    }
}