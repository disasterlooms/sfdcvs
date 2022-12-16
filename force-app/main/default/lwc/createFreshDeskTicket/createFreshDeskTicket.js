import { LightningElement,api } from 'lwc';
import createTicket from '@salesforce/apex/createFreshDeskTicket.createTicket';

export default class CreateFreshDeskTicket extends LightningElement {
    @api richTxtLabel;  
    @api myVal;
    @api fileUploadLabel;  
    @api multipleFiles;  
    

    handleChange(event) {
        this.myVal = event.target.value;
    }

    handleSubmission(event){
        createTicket({ email : 'somefakemail@masdf.com', name : 'some fake name'})
            .then(result => {
                console.log(result);
                //this.contacts = result;
            })
            .catch(error => {
                console.log(result);
                //this.error = error;
            });
    }
}