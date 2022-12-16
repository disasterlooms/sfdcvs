import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class StrategicAllocationATP extends LightningElement {
    @api isShowModal;
    connectedCallback(){
        this.isShowModal = false;
    }

    createAllocation(){
        console.log('create form');
        this.isShowModal = true;
    }
    closeModal(){
        console.log('close modal');
        this.isShowModal = false;
    }

    handleSuccess(event) {
        console.log('success !!!!');
       
        const evt = new ShowToastEvent({
            title: 'Request Created and submitted to Sales Admin',
            message: 'Record ID: ' + event.detail.id,
            variant: 'success',
        });
        this.dispatchEvent(evt);
        this.isShowModal = false;
    }
}