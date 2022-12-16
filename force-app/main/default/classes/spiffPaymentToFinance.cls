public without sharing class spiffPaymentToFinance {
    @AuraEnabled
    public static List<Spiff_Claim_Payment__c> updateFinance(){    
        
        String status = 'Approved';
        
        DescribeSObjectResult describeResult = Contact.getSObjectType().getDescribe();
        List< Spiff_Claim_Payment__c > paid = [Select id ,status__c from Spiff_Claim_Payment__c where status__c != 'Paid' ];
        for(Spiff_Claim_Payment__c s : paid){
            s.Status__c = 'Paid';
        }
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        
        
        DescribeSObjectResult describeSpiff = Spiff_Request__c.getSObjectType().getDescribe();
        
        List<String> SpifffieldNames = new List<String>( describeSpiff.fields.getMap().keySet() );
        List< Spiff_Claim_Payment__c > scp = new List< Spiff_Claim_Payment__c >();
        List< Spiff_Request__c > spiffs = new List< Spiff_Request__c >();
        //Map<Id, Spiff_Request__c >child = new Map< Id,Spiff_Request__c >();
        
        String query =		  ' SELECT ' +		      String.join( fieldNames, ',' ) +',Account.BillingCountry,(Select '+ String.join( SpifffieldNames, ',' )+  
            ' FROM spiff_requests__r where Status__c = :status ) '
            +	' FROM '+	      describeResult.getName()	+' WHERE id in (select Requester__c  from spiff_request__c where Status__c = :status) ';
        
      
        system.debug(query);
        List<Contact> records = Database.query( query ); 
        system.debug(records[0].Account.BillingCountry+' bil country');
        system.debug(records);
        
        for(Contact c: records){
            if(c.Legal_Last_Name__c != Null){
                c.LastName = c.Legal_Last_Name__c;
            }
            if(c.Legal_First_Name__c != Null){
                c.FirstName = c.Legal_First_Name__c;
            }
            Double qty =0;
            Double rev =0;
            Double qtyIFp =0;
            Double revIFP =0;
            Double qtyPJ =0;
            Double revPJ =0;
            Double qtyLCD =0;
            Double revLCD =0;
            Double qtyCd =0;
            Double revCD =0;
            for(Spiff_Request__c s : c.Spiff_requests__r){
                s.status__c = 'Submitted to Accounting';
                spiffs.add(s);
                
                qty = qty+s.Quantity__c;
                rev = rev+s.Total_Spiff_Amount__c;
                if(s.productLine__c == 'IFP'){
                    qtyIFp = qtyIFp+s.Quantity__c;
                    revIFP = revIFP+s.Total_Spiff_Amount__c;
                }else if(s.productLine__c == 'CD'){
                    qtyCd = qtyCd+s.Quantity__c;
                    revCD = revCD+s.Total_Spiff_Amount__c;
                }else if(s.productLine__c == 'LCD'){
                    qtyLCD = qtyLCD+s.Quantity__c;
                    revLCD = revLCD+s.Total_Spiff_Amount__c;
                }else if(s.productLine__c == 'PJ'){
                    qtyPJ = qtyPJ+s.Quantity__c;
                    revPJ = revPJ+s.Total_Spiff_Amount__c;
                }
            }
            
            if(c.Account.BillingCountry != 'Canada'){
                Spiff_Claim_Payment__c  sp = new Spiff_Claim_Payment__c ();
                //sp.finofferNumber__c = qty;
                sp.Product_Line__c = 'All';
                sp.finofferAmount__c = rev;
                sp.fincontactEmail__c  = c.Email;
                sp.finclaimerFname__c = c.FirstName;
                sp.finclaimerLname__c = c.LastName;
                sp.Contact__c = c.Id;
                scp.add(sp);
                
            }else if(c.Account.BillingCountry == 'Canada') {
                if(qtyIFp > 0){
                    Spiff_Claim_Payment__c  sp1 = new Spiff_Claim_Payment__c ();
                    sp1.Product_Line__c = 'IFP';
                    //sp1.finofferNumber__c = qtyIFp;
                    sp1.finofferAmount__c = revIFP;
                    sp1.finclaimerFname__c = c.FirstName;
                    sp1.finclaimerLname__c = c.LastName;
                    sp1.fincontactEmail__c  = c.Email;
                    sp1.Contact__c = c.Id;
                    scp.add(sp1);
                }
                if(qtyPJ > 0){
                    Spiff_Claim_Payment__c  sp2 = new Spiff_Claim_Payment__c ();
                    sp2.Product_Line__c = 'PJ';
                    //sp2.finofferNumber__c = qtyPJ;
                    sp2.finofferAmount__c = revPJ;
                    sp2.finclaimerFname__c = c.FirstName;
                    sp2.finclaimerLname__c = c.LastName;
                    sp2.fincontactEmail__c  = c.Email;
                    sp2.Contact__c = c.Id;
                    scp.add(sp2);
                }
                if(qtyLCD > 0){
                    Spiff_Claim_Payment__c  sp3 = new Spiff_Claim_Payment__c ();
                    sp3.Product_Line__c = 'LCD';
                    //sp3.finofferNumber__c = qtyLCD;
                    sp3.finofferAmount__c = revLCD;
                    sp3.finclaimerFname__c = c.FirstName;
                    sp3.finclaimerLname__c = c.LastName;
                    sp3.fincontactEmail__c  = c.Email;
                    sp3.Contact__c = c.Id;
                    scp.add(sp3);
                }
                if(qtyCd > 0){
                    Spiff_Claim_Payment__c  sp4 = new Spiff_Claim_Payment__c ();
                    sp4.Product_Line__c = 'CD';
                    //sp4.finofferNumber__c = qtyCd;
                    sp4.finofferAmount__c = revCD;
                    sp4.finclaimerFname__c = c.FirstName;
                    sp4.finclaimerLname__c = c.LastName;
                    sp4.fincontactEmail__c  = c.Email;
                    sp4.Contact__c = c.Id;
                    scp.add(sp4);
                }
            }
        }
        insert scp;
        update paid;
        
        Map<String,Spiff_Claim_Payment__c> pmts = new Map<String,Spiff_Claim_Payment__c>();
        for(Spiff_Claim_Payment__c s : [Select id, Product_Line__c, contact__c from Spiff_Claim_Payment__c where id in: scp]){
            pmts.put(s.contact__c+s.Product_Line__c, s);
            
        }
        
        for(Spiff_Request__c s : spiffs){
            if(pmts.containsKey(s.requester__c+s.productLineKey__c)){
                Spiff_Claim_Payment__c pm = pmts.get(s.requester__c+s.productLineKey__c);
                s.Spiff_Claim_Payment__c = pm.Id;                
            }
        }
        system.debug(spiffs);
        
        update spiffs;
        
        return scp;
                              
        
        
                        //update records;
                        /*    
                        c.spiffPmtQty__c = qty;
                        c.spiffPmtAmt__c = rev;           
                        c.spiffPmtQtyIFP__c  = qtyIFp;
                        c.spiffPmtAmtIFP__c = revIFP;
                        c.spiffPmtQtyPJ__c  = qtyPJ;
                        c.spiffPmtAmtPJ__c = revPJ;
                        c.spiffPmtQtyLCD__c  = qtyLCD;
                        c.spiffPmtAmtLCD__c = revLCD;
                        c.spiffPmtQtyCD__c  = qtyCd;
                        c.spiffPmtAmtCD__c = revCD;
                        */
    }
    
    
}