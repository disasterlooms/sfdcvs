import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import doMappingSync from '@salesforce/apex/GovSpendContactComponentController.doMappingSync';
import getCredits from '@salesforce/apex/GovSpendContactComponentController.getCredits';
export default class GovSpendContactComponent extends LightningElement {
  greeting = 'World';
  changeHandler(event) {
    this.greeting = event.target.value;
  }

  value;
  credits;
  //credits2 = credits!=null ? JSON.parse(credits) : null;

  @wire(getCredits, { searchId: '$value' })
  doGetCredits({error, data}){
    if(data){
      this.credits=data.totalRecords;
      console.log('hi');
      console.log(data);
      console.log(data.totalRecords);
     // console.log(JSON.parse(data));
      console.log(JSON.stringify(data));
      console.log('hi');
      //this.credits = JSON.parse(data);
    }
  }


  get options() {
      return [
          { label: 'TestingContactAPI2', value: '62e3ad68a7dc040031419e1e' },
          { label: 'TestingContactAPI3', value: '62f040cd18e780003187a592' },
          { label: 'Test Search 3', value: 'yellow' },
      ];
  }

  clickedButtonLabel;

  handleClick(event) {
      this.clickedButtonLabel = event.target.label;
      doMappingSync({ searchId: this.value })
      .then(result => {
        const event2 = new ShowToastEvent({
          title: "Success!",
          message: "Job queued. You will get an email when it completes.",
          variant: "success",
          mode: "sticky",
          });
          this.dispatchEvent(event2);
    })
    .catch(error => {
        this.error = error;
    });

  }


  handleChange(event) {
      this.value = event.detail.value;
  }


}