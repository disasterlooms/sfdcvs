import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { createRecord } from 'lightning/uiRecordApi';
import { updateRecord } from 'lightning/uiRecordApi';
import { getTicket } from 'lightning/uiRecordApi';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import freshdeskObj from '@salesforce/schema/freshdesk__Freshdesk_Ticket_Object__c';
import fdsources from '@salesforce/schema/freshdesk__Freshdesk_Ticket_Object__c.FD_Group__c';
import NAME_FIELD from '@salesforce/schema/freshdesk__Freshdesk_Ticket_Object__c.Name';
import TICKET_FIELD from '@salesforce/schema/freshdesk__Freshdesk_Ticket_Object__c.freshdesk__TicketID__c';
import ACCTID from '@salesforce/schema/freshdesk__Freshdesk_Ticket_Object__c.freshdesk__SalesforceAccount__c';
import DESCRIPTION from '@salesforce/schema/freshdesk__Freshdesk_Ticket_Object__c.Ticket_RTF_Description__c';
import ID_FIELD from '@salesforce/schema/freshdesk__Freshdesk_Ticket_Object__c.Id';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import jQuery from '@salesforce/resourceUrl/jQueryAttachments';
import freshCreds from '@salesforce/apex/createFreshDeskTicket.getFreshDeskCredentials';


import {
    FlowAttributeChangeEvent,
    FlowNavigationNextEvent,
    FlowNavigationFinishEvent,
} from 'lightning/flowSupport';
import createTicket from '@salesforce/apex/createFreshDeskTicket.createTicket';
import updateDescriptionImages from '@salesforce/apex/createFreshDeskTicket.updateTicket';

export default class CreateFreshDeskTicket extends LightningElement {
    @api richTxtLabel;
    @api description;
    @api account;
    @api accountId;
    @api subject;
    @api name;
    @api email;
    @api fileUploadLabel;
    @api multipleFiles;
    @api isLoaded;
    @api calloutError;
    @api outlook;
    @api refreshcmp;
    @api groups;
    @api csgroup;
    @api ccuser;
    @api freshdeskId;
    sendAttachment;

    @wire(freshCreds) freshdeskCreds;

    get options() {
        return [
            { label: 'Customer Service', value: 'Customer Service' },
            { label: 'Technical Support', value: 'Technical Support' },
            { label: 'Field Solutions', value: 'Field Solutions' },
        ];
    }
    connectedCallback() {
        this.ccuser = false;
        this.isLoaded = true;
        console.log('subject ' + this.subject);
        this.calloutError = false;
        this.sendAttachment = true;
        loadScript(this, jQuery)
        .then(() => {
            console.log('JQuery loaded.');
    
        })
        .catch(error=>{
            console.log('Failed to load the JQuery : ' +error);
        });

        //console.log('from emaiil '+$people.from.email);
        //this.value = 'Customer Service';
        //this.csgroup = 'Customer Service';

    }
    handleChangeSubject(event) {
        this.subject = event.target.value;

    }
    handleChangeEmail(event) {
        this.email = event.target.value;

    }
    handleChangeName(event) {
        this.name = event.target.value;

    }
    handleCCMeChange(event) {
        this.ccuser = event.target.checked;
        console.log(' checkbox cc ' + this.ccuser);
    }
    handleChangeGroup(event) {
        this.csgroup = event.target.value;
        console.log('pick value ' + this.csgroup);
    }
    handleChangeDescription(event) {
        this.description = event.target.value;
        //console.log( event.target.value);     
    }
    showNotification() {
        const evt = new ShowToastEvent({
            title: this._title,
            message: this.message,
            variant: this.variant,
        });
        this.dispatchEvent(evt);

    }
    handleSubmission(event) {
        this.isLoaded = !this.isLoaded;
        if (!this.accountId) {
            this.variant = 'error';
            this.message = 'Please add an Account';
            this._title = 'Please add a Account';
            this.showNotification();
            this.isLoaded = true;
            return;
        }
        var desc = this.description;
        if (!desc) {
            this.variant = 'error';
            this.message = 'Please add a description';
            this._title = 'Please add a description';
            this.showNotification();
            this.isLoaded = true;
            return;

        } else if (desc.includes('"')) {
            console.log('quotes exist in desc');

        } else {
            console.log('not null but no quotes');
        }
        // update description and if successfull create ticket





        const isInputsCorrect = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputField) => {
                inputField.reportValidity();
                return validSoFar && inputField.checkValidity();
            }, true);

        const isPicklistCorrect = [...this.template.querySelectorAll('lightning-combobox')]
            .reduce((validSoFar, inputField) => {
                inputField.reportValidity();
                return validSoFar && inputField.checkValidity();
            }, true);

        if (isInputsCorrect && isPicklistCorrect) {
            console.log('validation passed !');

            //update the description with better url links before sending to freshdesk

            updateDescriptionImages({ description: this.description })
                .then(result => {
                    console.log('here is updated description ');
                    console.log(result);
                    var desc = result.replace(/"/g, '\\"');
                    console.log(desc);
                    console.log(this.description);
                    createTicket({
                        email: this.email, name: this.name
                        , subject: this.subject
                        , description: desc, acctId: this.accountId, fdgroup: this.csgroup, addemails: this.ccuser
                    })

                        .then(result => {
                            this.isLoaded = true;
                            debugger;
                            if (result != 'Error') {
                                console.log('successfully created ticket with no error on the callback code');
                                console.log('result ');
                                console.log(result);
                                console.log('neilresult'+result.id);
                                //console.log('stringified');
                                //console.log(JSON.stringify(result));
                                try {
                                    var parsed = JSON.parse(result);
                                    console.log('neilparsed'+parsed);
                                    console.log('neil id'+parsed.id);
                                    if(this.sendAttachment&&(this.template.querySelector('input').files.length>0)){
                                        this.attachmentCallout(parsed.id);
                                    }
                                    //console.log(parsed.id);                            

                                } catch (e) {
                                    console.log('there was an error updating FD Ticket');
                                    console.log(e);
                                }
                                this.variant = 'success';
                                this.message = 'The ticket has been created and will be viewable in the Salesforce Freshdesk app in 24 hours';
                                this._title = 'Congrats, the ticket was sent to Customer Service';
                                this.showNotification();
                                console.log('outlok panel ' + this.outlook);
                                if (this.outlook || this.outlook == "true") {
                                    console.log('reloading outlook panel');
                                    const value = Math.random() * 1035;
                                    const valueChangeEvent = new CustomEvent("valuechange", {
                                        detail: { value }
                                    });
                                    // Fire the custom event
                                    this.dispatchEvent(valueChangeEvent);

                                } else {
                                    console.log('finishing flow');
                                    const navigateNextEvent = new FlowNavigationFinishEvent();
                                    this.dispatchEvent(navigateNextEvent);

                                }

                            } else {
                                console.log('error none 201 code');
                                this.variant = 'error';
                                this.calloutError = true;
                                this.message = 'Sorry, we got an error when creating this ticket.';
                                this._title = 'Sorry there was an error. Please notify Admin of the error';
                                this.showNotification();

                            }

                        })
                        .catch(error => {
                            this.isLoaded = true;
                            //console.log(error);
                            console.log('error on the callback catch line 139');
                            const navigateNextEvent = new FlowNavigationFinishEvent();
                            //this.dispatchEvent(navigateNextEvent);
                            this.variant = 'error';
                            this.calloutError = true;
                            this.message = 'Sorry, we got an error when creating this ticket.';
                            this._title = 'Sorry there was an error. Please notify Admin of the error';
                            this.showNotification();
                        });
                })

                .catch(error => {
                    console.log('error in updating description links ');
                    console.log(error);
                    this.isLoaded = true;
                    const navigateNextEvent = new FlowNavigationFinishEvent();
                    //this.dispatchEvent(navigateNextEvent);
                    this.variant = 'error';
                    this.calloutError = true;
                    this.message = 'Sorry, we got an error when creating this ticket. Please let admin know there was an error in updating descriptions links';
                    this._title = 'Sorry there was an error. Please notify Admin of the error';
                    this.showNotification();

                })

        } else {
            this.isLoaded = true;
        }
    }
    attachmentsValidate(){
        console.log(this.freshdeskCreds.data.API_Key__c);
        console.log('neilfresh '+JSON.stringify(this.freshdeskCreds));
        var attachFiles = this.template.querySelector('input').files;
        var collectiveFileSize=0;
        for (var i=0; i<attachFiles.length; i++){
            collectiveFileSize+=attachFiles[i].size;
        }
        console.log('Total file size is '+(collectiveFileSize / 1024 / 1024));
        if((collectiveFileSize / 1024 / 1024)>20){
            this.sendAttachment=false;
        }
        else{
            this.sendAttachment=true;
        }
    }
    attachmentCallout(ticketId){
                var yourdomain = this.freshdeskCreds.data.url__c; 
                var api_key = this.freshdeskCreds.data.API_Key__c;
                console.log(this.template.querySelector('input'));
                console.log(this.template.querySelector('input').files);
                var attachFiles = this.template.querySelector('input').files;

              //  console.log(document.querySelector('input'));
                var formdata = new FormData();
                for (var i=0; i<attachFiles.length; i++){
                    formdata.append('attachments[]', this.template.querySelector('input').files[i]);
                }
                $.ajax(
                  {
                    url: yourdomain+'tickets/'+ticketId,
                    type: 'PUT',
                    contentType: false,
                    processData: false,
                    headers: {
                      "Authorization": "Basic " + btoa(api_key + ":x")
                    },
                    data: formdata,
                    success: function(data, textStatus, jqXHR) {
                        console.log('Success!');
                /*      $('.result').text('Success');
                      $('#code').text(jqXHR.status);
                      $('#response').html(JSON.stringify(data, null, "<br/>"));*/
                    },
                    error: function(jqXHR, tranStatus) {
                     /* $('#result').text('Error');
                      $('#code').text(jqXHR.status);
                      x_request_id = jqXHR.getResponseHeader('X-Request-Id');
                      response_text = jqXHR.responseText;
                      $('#response').html(" Error Message : <b style='color: red'>"+response_text+"</b>.<br/> Your X-Request-Id is : <b>" + x_request_id + "</b>. Please contact support@freshdesk.com with this id for more information.");*/
        
                    }
                  }
                );
              }
}