import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class OpenFileSample extends NavigationMixin(LightningElement) {

    navigateToFiles() {
      this[NavigationMixin.Navigate]({
        type: 'standard__namedPage',
        attributes: {
            pageName: 'filePreview'
        },
        state : {
            recordIds: '0695c00000BqjjdAAB',
            selectedRecordId:'0695c00000BqjjdAAB'
        }
      })
    }

}