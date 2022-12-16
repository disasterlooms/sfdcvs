import { LightningElement,api,wire } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import TICKET_CHANNEL from '@salesforce/messageChannel/freshdeskMessage__c';

export default class ManualFDTicketSearch extends LightningElement {
    @wire(MessageContext)
   messageContext;
    queryTerm;
    handleKeyUp(event){
        if(event.keyCode === 13){
        console.log('valuie ' +event.target.value);
        const payload = { 
            ticketId : event.target.value
          };
        publish(this.messageContext, TICKET_CHANNEL, payload);
        //this.queryTerm = event.target.value;
        }

    }
}