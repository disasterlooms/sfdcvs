import { LightningElement,wire,api } from 'lwc';
import getCountries from '@salesforce/apex/countryStatesLWC.getCountries';
import getAddresses from '@salesforce/apex/countryStatesLWC.getAddresses';
import getBillingAddresses from '@salesforce/apex/countryStatesLWC.getBillingAddresses';
import getStates from '@salesforce/apex/countryStatesLWC.getStates';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent } from 'lightning/flowSupport';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { CloseActionScreenEvent } from 'lightning/actions';


export default class InputAddressBase extends LightningElement {
    @api
    availableActions = [];
    @api recordId;
    @api street;
    @api showAddressHistory;
    @api showAddressUpdate;
    @api city;
    @api billingContact;
    @api Company;
    @api FirstName;
    @api LastName;
    @api phone;
    @api email;
    @api state;
    @api country;
    @api postal;
    @api PersonId;
    @api addressChanged;
    @api contactDefault
    @api getBillingInfo
    @api displayDefaultOption
    listofAddresses;
    listCountries;
    canadaStates;
    usStates;
    mexicoStates;
    brazilStates;
    chinaStates;
    italyStates;
    validBill;
    @wire(getCountries) countries;
    @wire(getStates) states;
    



    connectedCallback(){
        this.objectApiName = 'Account';
        console.log('see if cit exists '+ this.street+' '+this.city+' '+this.state+' '+this.country+' ');
        console.log('record id '+this.recordId);
        this.address = {street: this.street, city: this.city, province: this.state, postalCode: this.postal, country : this.country};
        getCountries()
            .then(result => {
                let tempArray =[];
                for(var i=0; i<result.length; i++) {
                    console.log('Country Results');
                    tempArray .push({ label: result[i].Country__c, value: result[i].CountryCode__c});
                    
                }   
                //console.log(tempArray);
                this.listCountries = tempArray;
            })
            .catch(error => {
                this.error = error;
                console.log(error);
            });
            if(this.getBillingInfo){
                console.log('Getting billing addresses');
                getBillingAddresses({ evalId: this.recordId })
                    .then(result => { 
                        this.listofAddresses = result;
                        console.log(this.listofAddresses);
                    })
                    .catch(error => {
                        this.error = error;
                        console.log(error);
                        console.log('error getting addresses');
                    });
            }else{
                console.log('Getting shipping addresses');
                getAddresses({ persId: this.PersonId })
                    .then(result => {     
                        this.listofAddresses = result;
        
                        //console.log('address result ');
                        console.log(this.listofAddresses);
                    })
                    .catch(error => {
                        this.error = error;
                        console.log(error);
                        console.log('error getting addresses');
                    });
            }
            

            getStates()
            .then(result => {
                // lets do Canada

                let Canada = [];
                let US = [];
                let Mexico = [];
                let Brazil = [];
                let China = [];
                let Italy = [];

                console.log('Canada ');
                for(var i=0; i<result.length; i++) {
                    if(result[i].CountryCode__c == 'CA'){
                        Canada .push({ label: result[i].State__c, value: result[i].StateCode__c});
                    }else if(result[i].CountryCode__c == 'US'){
                        US .push({ label: result[i].State__c, value: result[i].StateCode__c});
                    }else if(result[i].CountryCode__c == 'MX'){
                        Mexico .push({ label: result[i].State__c, value: result[i].StateCode__c});
                    }else if(result[i].CountryCode__c == 'BR'){
                        Brazil .push({ label: result[i].State__c, value: result[i].StateCode__c});
                    }else if(result[i].CountryCode__c == 'CN'){
                        China .push({ label: result[i].State__c, value: result[i].StateCode__c});
                    }else if(result[i].CountryCode__c == 'IT'){
                        Italy .push({ label: result[i].State__c, value: result[i].StateCode__c});
                    }
                    
                    
                } 
                this.canadaStates = Canada;
                this.usStates = US;
                this.mexicoStates = Mexico;
                this.brazilStates = Brazil;
                this.chinaStates = China;
                this.italyStates = Italy;


                

            })
            .catch(error => {
                this.error = error;
                console.log(error);
            });
    }
    
    errorMsg = '';
    address = {
        street: '',
        city: '',
        province: '',
        postalCode: '',
        country: '',
    };
    countryStateMaps = {};
    countryProvinceMap = {
        US: [
            { label: 'California', value: 'CA' },
            { label: 'Texas', value: 'TX' },
            { label: 'Washington', value: 'WA' },
        ],
        CA: this.listCountries,
        VA: [],
    };

    get getProvinceOptions() {
        let country = "US";
        if(this.country == "CA"){
            return this.canadaStates;
        }else if(this.country == "US"){
            return this.usStates;
        }else if(this.country == "MX"){
            return this.mexicoStates;
        }else if(this.country == "BR"){
            return this.brazilStates;
        }else if(this.country == "CN"){
            return this.chinaStates;
        }else if(this.country == "IT"){
            return this.italyStates;
        }
        else{
            this.address = {
                province : null
            };
            return null;
            
        }
        //return this.countryProvinceMap[this._country];
    }
    get getCountryOptions() {
        return this.listCountries;
    }
    closeAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
    fnameChange(event){
        console.log('handle change');
        console.log(event.target.value);
        this.FirstName = event.target.value;
    }
    companyChange(event){
        console.log('handle change');
        console.log(event.target.value);
        this.Company = event.target.value;
    }
    lnameChange(event){
        console.log('handle change');
        console.log(event.target.value);
        this.LastName = event.target.value;
    }
    


    
    handleChange(event) {
       
        
        this.country = event.detail.country;
        this.street = event.detail.street;
        this.city = event.detail.city;
        this.state = event.detail.province;
        this.postal = event.detail.postalCode;
        console.log('email change');
        this.addressChanged = true;
    }

    addressSelection(event){
        console.log(event.target.company);
        const adr = this.template.querySelector('lightning-input-address');
            var id = event.target.name;
            console.log('id '+ id);
            console.log('Company '+ this.listofAddresses[id].Company__c);
            console.log('Street '+ this.listofAddresses[id].Street__c);
            this.Company = this.listofAddresses[id].Company__c;
            this.FirstName = this.listofAddresses[id].Company__c;
            this.LastName = this.listofAddresses[id].Company__c;

            this.street = this.listofAddresses[id].Street__c;
            this.city = this.listofAddresses[id].City__c;
            this.state = this.listofAddresses[id].State_Province__c;
            this.country = this.listofAddresses[id].Country__c;
            this.postal = this.listofAddresses[id].Postal_Code__c;
            
            adr.street = this.listofAddresses[id].Street__c;
            adr.city = this.listofAddresses[id].City__c;
            adr.province = this.listofAddresses[id].State_Province__c;
            adr.country = this.listofAddresses[id].Country__c;
            adr.postalCode = this.listofAddresses[id].Postal_Code__c;
             
              

        this.template.querySelectorAll('[data-element="address-checkbox"]')
            .forEach(element => { element.checked = false; });           
            event.target.checked = true;
    }
    handleCheckboxChange(event){
        this.contactDefault = event.target.checked;
    }
    emailChange(event) {
        this.email = event.detail.value;
        console.log('new email '+ event.detail.value);
    }
    phoneChange(event) {
        this.phone = event.detail.value;
    }
    getBillingValidated(){
        var valid = false;
        if(this.getBillingInfo){
            if(this.Company && this.FirstName && this.LastName){
                valid = true;
            }
        }else{
            valid = true;

        }

        return valid;
    }
    handleGoNext(event) {
                // check if NEXT is allowed on this screen
        if (this.availableActions.find(action => action === 'NEXT')) {
            
            
            const navigateNextEvent = new FlowNavigationNextEvent();
            console.log(this._street+' '+this._city+' '+this._province+' '+this._postal+' '+this._country );
            console.log(this.street+' '+this.city+' '+this.state+' '+this.postal+' '+this.country );
            console.log('2 addresses with variables')
            //country with states is for Countries that require a state input which will 
            //grow over time but will start with states below
            //jason orbison 9.16
            const countryWithStates = ["US", "CA"];
            var countryField = this.country  // Or wherever you have your country input stored.
            //console.log('country '+country.toString());
            const address = this.template.querySelector('lightning-input-address');
            //this.BillingCompany =
            console.log('state');
            console.log(this.state);
            console.log('country '+ countryField);
            console.log('address Country');
            //console.log(address.get('Country'));
            console.log('is country in list of exlusions? '+(this.country == 'US' || this.country == 'CA'));
            
            if (!countryField) {
              console.log('country doesnt exists');
              address.setCustomValidityForField('Country is a required field', 'country');
            }
            if(!this.state && countryWithStates.includes(countryField)) {
                console.log('there is not province');
                address.setCustomValidityForField('State/Province required for selected country', 'province');
               
            }
            if(!this.street) {
                address.setCustomValidityForField('Street is a required field', 'street');
            }
            if(!this.city) {
                address.setCustomValidityForField('City is a required fieldd', 'city');
            }
            if(!this.postal) {
                address.setCustomValidityForField('Postal Code is a required field', 'postalCode');
            }
            console.log('email '+this.email);
            this.validBill = this.getBillingValidated();
            console.log(this.validBill);
            if(this.phone&& this.email&&countryField && this.postal &&
                  this.street && this.city
                && (this.state || (this.country != 'US'
                 &&  this.country != 'CA'
                 &&  this.country != 'CA')) && this.validBill){
                    
                this.dispatchEvent(navigateNextEvent);
            }else{                
                this.errorMsg = 'Phone, Email , Street, City, Country and Postal Code are required. State/Province required for some countries';
                                   
            }  

            
           
        }
    }
    
}