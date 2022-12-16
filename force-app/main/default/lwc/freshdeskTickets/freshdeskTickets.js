import { LightningElement, api } from 'lwc';

export default class FreshdeskTickets extends LightningElement {
  @api results;
  @api metadata;
  @api selection;
  @api setSelection;
  @api selectMode;
  @api getState;
  @api setState;
  @api refresh;
  @api ticketId;
  @api recordId;
  
  companyChange(event){
    console.log('handle change');
    console.log(event.target.value);
    this.Company = event.target.value;
}
}