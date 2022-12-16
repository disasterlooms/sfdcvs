import { LightningElement, track, api } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import csvFileRead from '@salesforce/apex/fileUploadCSV.csvFileRead';

const columnsSerials = [
    { label: 'Serial Number', fieldName: 'SerialNumber'},
     {label: 'Spiff Request', fieldName: 'Spiff_Name__c'},
     {label: 'Error Message', fieldName: 'Notes__c'}
];

export default class cSVFileReadLWC extends LightningElement {
    @api recordId;
    @track error;
    @track columnsSerials = columnsSerials;
    @track data;
    loaded = true;
    connectedCallback() {
        console.log('record id '+this.recordId);
    }
   
    // accepted parameters
    get acceptedCSVFormats() {
        return ['.csv'];
    }
    
    uploadFileHandler(event) {
        // Get the list of records from the uploaded files
        this.loaded = !this.loaded;
        const uploadedFiles = event.detail.files;
        console.log('record id '+this.recordId);
        // calling apex class csvFileread method
        csvFileRead({contentDocumentId : uploadedFiles[0].documentId,
        recordId : this.recordId})
        .then(result => {
            window.console.log('result ===> ');
            console.log(result);
            this.data = result;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success!!',
                    message: 'Accounts are created according to the CSV file upload!!!',
                    variant: 'Success',
                }),
            );
            this.loaded = !this.loaded;
        })
        .catch(error => {
            this.error = error;
            console.log(error);
            console.log(error.message);
            console.log(error.body);
            console.log(error.body.message);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error!!',
                    message: error.body,
                    variant: 'error',
                }),
            );
            this.loaded = !this.loaded;     
        })

    }
    downloadCSVFile() {   
        let rowEnd = '\n';
        let csvString = '';
        // this set elminates the duplicates if have any duplicate keys
        let rowData = new Set();

        // getting keys from data
        this.data.forEach(function (record) {
            Object.keys(record).forEach(function (key) {
                rowData.add(key);
            });
        });

        // Array.from() method returns an Array object from any object with a length property or an iterable object.
        rowData = Array.from(rowData);
        
        // splitting using ','
        csvString += rowData.join(',');
        csvString += rowEnd;

        // main for loop to get the data based on key value
        for(let i=0; i < this.data.length; i++){
            let colValue = 0;

            // validating keys in data
            for(let key in rowData) {
                if(rowData.hasOwnProperty(key)) {
                    // Key value 
                    // Ex: Id, Name
                    let rowKey = rowData[key];
                    // add , after every value except the first.
                    if(colValue > 0){
                        csvString += ',';
                    }
                    // If the column is undefined, it as blank in the CSV file.
                    let value = this.data[i][rowKey] === undefined ? '' : this.data[i][rowKey];
                    csvString += '"'+ value +'"';
                    colValue++;
                }
            }
            csvString += rowEnd;
        }

        // Creating anchor element to download
        let downloadElement = document.createElement('a');

        // This  encodeURI encodes special characters, except: , / ? : @ & = + $ # (Use encodeURIComponent() to encode these characters).
        downloadElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csvString);
        downloadElement.target = '_self';
        // CSV File Name
        downloadElement.download = 'Serial and Spiff Data.csv';
        // below statement is required if you are using firefox browser
        document.body.appendChild(downloadElement);
        // click() Javascript function to download CSV file
        downloadElement.click(); 
    }
}