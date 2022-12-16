import { LightningElement, api, track} from 'lwc';
import {exportCSVFile} from 'c/exportCSVFile'
// imported to show toast messages
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

const cols = [
    {label: 'Name',fieldName: 'Name'}, 
    {label: 'Serial Number',fieldName: 'SerialNumber'}
];
export default class ExportDataToCSVInLWC extends LightningElement {
    @api records;
    @api fileName;
    @api buttonlabel;
    @api buttontitle;    
    @track data;
    @track columns = cols;
    @track loaded
    @track file; 
    // this method validates the data and creates the csv file to download
    connectedCallback() {
        //this.records = this.records;
        this.loaded = true;
        this.data = this.records;
        
      }
    downloadCSVFile() {
        this.loaded =  !this.loaded;
        console.log('load spinner '+this.loaded);
        this.data = this.records;
        console.log('data rows ' + this.data.length);
        console.log('serial rows '+ this.records.length);
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
        downloadElement.download = this.fileName+'.csv';
        // below statement is required if you are using firefox browser
        document.body.appendChild(downloadElement);
        // click() Javascript function to download CSV file
        downloadElement.click(); 

        this.loaded = !this.loaded;
    }
}