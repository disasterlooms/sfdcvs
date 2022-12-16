public with sharing class ProdAccExtension {

    private final Product2 prod;
    private ApexPages.StandardController stdController;
	public List<Accessories__c> accs=new List<Accessories__c>();
    public ProdAccExtension(ApexPages.StandardController stdController) {
        this.prod = (Product2)stdController.getRecord();
        this.stdController = stdController;
    }

    public List<Accessories__c> getaccs()
    {
       
          accs = [SELECT Id, Name, Accessory_Product__c, AutoAdd__c, Main_Product__c, ProdAccId__c from Accessories__c
                  where Main_Product__c=: prod.Id];
        
                    system.debug('accessories '+accs);
        return accs;
    }
   public void updateaccs(){   
   	update accs;
 }

}