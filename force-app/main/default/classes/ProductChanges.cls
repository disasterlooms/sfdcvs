public class ProductChanges{
        // These variables store Trigger.oldMap and Trigger.newMap
        Map<Id, Product2> oldProds;
        Map<Id, Product2> newProds;
        
        List<Product2> acctsToUpdate = new List<Product2>();
        // This is the constructor
        // A map of the old and new records is expected as inputs
        public ProductChanges(
            Map<Id, Product2> oldTriggerProds, 
            Map<Id, Product2> newTriggerProds) {
                oldProds = oldTriggerProds;
                newProds = newTriggerProds;
            }
        
        public static void newproduct(List<Product2> records) {
            
            try{
                for(Product2 p : records){
                system.debug(p.name.substring(0, 3));
                system.debug('name');
                p.CanUseQuantitySchedule = true;
                if( p.name.substring(0, 3) == 'IFP' || p.name.substring(0, 3) == 'CDE'){
                    Integer i;
                    String s;
                    s = p.name.substring(3, 5);
                    system.debug('prodsize');
                    system.debug(s);
                    try{
                        i=integer.valueof(s);
                        if(i > 54 ){
                            p.Eval_Special_Approval__c = true;
                        }
                    }catch(Exception e){
                        
                    }
                    
                    
                }
            }
                
            }catch(Exception er){
                String t = 'Error product insert '+records[0].name;
                AdminErrorMessage.SendError(er, t);
            }
            
            
            
        }
        
        // The one method your master trigger will call
        public void LandingCostChange() {
            
            //get a new list of products that the landing costs have changed
            
            List<Product2> plandchange = new List<Product2>();
            for(Product2 p : newProds.values()){
                
                Product2 o  = oldProds.get(p.Id);
                if(o.Cost__c != p.Cost__c && p.IsActive == true){
                    
                    p.LandedCostChange__c = true;
                    
                }
            } 
            
            //send product list to future method so that the oppline items that need changed will be changed. 
            //String jsonString = json.serialize(plandchange);
            //ProductLandingCosts.UpdateOppLines(jsonString);
        }
    }