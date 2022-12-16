public without sharing class OpplineItems
{
    public static void UpdateMarginsfromProducts(List<Product2> records)
    {

    	// add a line item list to update after query
        List<OpportunityLineItem> lineitems = new  List<OpportunityLineItem> ();

        //Query and iterate over a all oppline items that are affected by the change in list prices. 

        for(OpportunityLineItem line : [Select Id, Product2Id,Margin__c,MarginText__c,	ListPrice,	Landing_Cost2__c,
         					Landed_Cost__c,Product2.Cost__c from OpportunityLineItem where Product2Id In: records]){

        	  line.MarginText__c = String.valueOf(line.Margin__c)+'%';
        	  Line.Landing_Cost2__c = Line.Product2.Cost__c;

        	  lineitems.add(line);

         }

         update lineitems;
      
    }
}