import { LightningElement,wire,api } from 'lwc';
import getacctInfo from '@salesforce/apex/updateAcctOwnerLWC.getCorrectOwner';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { updateRecord } from 'lightning/uiRecordApi';
import OWNERUPDATE from '@salesforce/schema/Account.ownerUpdateAttempt__c';
import OWNERFIELD from '@salesforce/schema/Account.OwnerId';
import ID_FIELD from '@salesforce/schema/Account.Id';
import { refreshApex } from '@salesforce/apex';



export default class WireFunction extends LightningElement {
@api recordId;    
@api ownerUpdateAttempt;
@api error;
@api message;
@api spinner;
@api isLoaded;
@api owner;
connectedCallback(){
    //acctId: this.recordId 
    this.isLoaded = false; 
    console.log(this.recordId);
    console.log('this.recordId');
    try{
        console.log($recordId);
    }catch(e){
        console.log(' $recordId did not work ');
    }
    
    getacctInfo({ acctId : this.recordId })
        .then(res => {
            console.log('returned with data !');
            console.log(res);
            if(res == 'Owner matches Rules'){
                this.isLoaded = false;
                console.log('owner matches ! doing nothing');
            }else if(res == 'No Owner Found'){
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error updating Owner, please update manually and notify IT help desk',
                        variant: 'error'
                    })
                );
                this.isLoaded = false;
                console.log('need manual match (;');
            }else if(res == 'Not Checked'){
                
                this.isLoaded = false;
                console.log('already checked');
            }else{
                this.isLoaded = true;
                this.owner = res;
                console.log('we got this');
                this.updateAccount();   
            }
        })
        .catch(error => {
            this.isLoaded = false;
            this.error = error;
            console.log(error);
            console.log('there was a callback error');
        });
    }

    updateAccount() {
            // Create the recordInput object
            const fields = {};
            fields[ID_FIELD.fieldApiName] = this.recordId;
            fields[OWNERUPDATE.fieldApiName] = true;
            fields[OWNERFIELD.fieldApiName] = this.owner;

            const recordInput = { fields };

            updateRecord(recordInput)
                .then(() => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Account updated',
                            variant: 'success'
                        })
                    );
                    // Display fresh data in the form
                    console.log('udpated owner data');
                    window.location.reload();
                })
                .catch(error => {
                    console.log(error.body.message);
                    console.log(error.body);
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error updating Owner, please update manually and notify IT help desk',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                    this.isLoaded = false;
                });
            
    }
    

}