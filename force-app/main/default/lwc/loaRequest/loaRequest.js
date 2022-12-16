import { LightningElement, wire } from 'lwc';
import getUserContact from '@salesforce/apex/LOARequestController.getUserContactInfo';
import submitLOA from '@salesforce/apex/LOARequestController.insertLOARequest';
//import uploadFile from '@salesforce/apex/LOARequestController.uploadFile'

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LightningConfirm from 'lightning/confirm';
import LightningAlert from 'lightning/alert';
import stateTaxRequirements from '@salesforce/resourceUrl/StateTaxRequirements';
import Id from '@salesforce/user/Id';
import { getRecord } from 'lightning/uiRecordApi';
import UserNameFld from '@salesforce/schema/User.Name';
import userEmailFld from '@salesforce/schema/User.Email';
import userIsActiveFld from '@salesforce/schema/User.IsActive';
import userAliasFld from '@salesforce/schema/User.Alias';




export default class LoaRequest extends LightningElement {
  greeting = 'World';
  changeHandler(event) {
    this.greeting = event.target.value;
  }

expirationDateChange(event){
  this.expirationDate= event.target.value;
  console.log(this.expirationDate);
}

businessTaxIDChange(event){
  this.businessTaxID=event.target.value;
}
fileData;
isSubmitted=false;
isLoading=false;
expirationDate;
businessTaxID='';
userId = Id;
currentUserName;
currentUserEmailId;
currentIsActive;
currentUserAlias;
 // contact;
conEmail;
conName;
conAccountName;
conOracle;
conAddress='';

@wire(getRecord, { recordId: Id, fields: [UserNameFld, userEmailFld, userIsActiveFld, userAliasFld ]}) 
userDetails({error, data}) {
    if (data) {
      console.log('hi');
        this.currentUserName = data.fields.Name.value;
        this.currentUserEmailId = data.fields.Email.value;
        this.currentIsActive = data.fields.IsActive.value;
        this.currentUserAlias = data.fields.Alias.value;
    } else if (error) {
        this.error = error ;
    }
}



  @wire(getUserContact)
  doGetCredits({error, data}){
    if(data){
     // this.contact=data;
     this.conEmail=data.Email;
     this.conName = data.FirstName;
     this.conName+=' ';
     this.conName+=data.LastName;
     this.conAccountName=data.Account.Name;
     this.conOracle=data.FinchOracleId__c;
     this.businessTaxID=data.Account.Reseller_Certificate__c;
     this.conAddress=data.Account.BillingAddress.street==null ? this.conAddress : data.Account.BillingAddress.street + ', ';
     this.conAddress=data.Account.BillingAddress.city==null ? this.conAddress : this.conAddress + data.Account.BillingAddress.city + ', ';
     this.conAddress=data.Account.BillingAddress.state==null ? this.conAddress : this.conAddress + data.Account.BillingAddress.state + ', ';
     this.conAddress=data.Account.BillingAddress.postalCode==null ? this.conAddress : this.conAddress + data.Account.BillingAddress.postalCode + ', ';
     this.conAddress=data.Account.BillingAddress.country==null ? this.conAddress : this.conAddress + data.Account.BillingAddress.country;

     console.log(data.FirstName);
     console.log(this.conEmail);
      console.log('hi');
      console.log(data);
    //  console.log(contact);
     // console.log(JSON.parse(data));
      console.log(JSON.stringify(data));
     // console.log(JSON.stringify(contact));

      console.log('hi');
      //this.credits = JSON.parse(data);
    }
    if(error){
      console.log('error');
      console.log(JSON.stringify(error));
    }
  }

  handleUploadFinished(event) {
    // Get the list of uploaded files
    const uploadedFiles = event.detail.files;
    let uploadedFileNames = '';
    for(let i = 0; i < uploadedFiles.length; i++) {
        console.log('file uploaded');
        console.log(JSON.stringify(uploadedFiles[i]));

    }

}

handleFilesChange(event) {
  const filesList = event.detail.files;
  console.log(filesList[0]);
}

handleClick(event) {
  this.isLoading=true;
  submitLOA({ resellerNo: this.businessTaxID, expDate: this.expirationDate })
  .then(result => {
    this.isLoading=false;
    this.isSubmitted=true;

})
.catch(error => {
    this.error = error;
});

}

openfileUpload(event) {
  const file = event.target.files[0];
  var reader = new FileReader();
  var base64obj;
  var recordIds = 'a4z78000000BLn2AAG';
  var filenames;
  reader.onload = () => {
      base64obj=reader.result.split(',')[1];
      filenames = file.name;
      console.log(base64obj);
      console.log(this.fileData);
        uploadFile({ base64: base64obj, filename: filenames, recordId: recordIds }).then(result=>{
     
  });

  }
  
  reader.readAsDataURL(file);
  console.log('neil'+this.base64obj);
  //const {base64, filename, recordId} = this.fileData;

}



}