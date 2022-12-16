import { LightningElement,wire,api } from 'lwc';
import getCountries from '@salesforce/apex/EvalUnitstoQuote.getUnits';

export default class EvalUpdateProductStatus_Community extends LightningElement {
    @api recordId;
    connectedCallback(){
        console.log('runn the search but need the recordid x  '+this.recordId);
    }


}