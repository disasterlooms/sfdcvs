import { LightningElement, api } from 'lwc';
import { ingestDataConnector } from 'lightning/analyticsWaveApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { createDataflowJob } from 'lightning/analyticsWaveApi';

export default class IngestCMSDataConnector extends LightningElement {
    @api CMS;

    command = 'start';
    @api showRecipe = false; 

    
    ingest(event) {
        ingestDataConnector({ connectorIdOrApiName : '0It780000004CB4CAM' } )
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Sync to TCRM!',
                        variant: 'success'
                    })
                );
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error ingesting data connector',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        });
        this.showRecipe = true;
    }

    ingest2(event) {
        createDataflowJob({ dataflowJob: { dataflowId: '02K78000000AWXvEAO', command: this.command } })
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Recipe Started',
                        variant: 'success'
                    })
                );
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error starting recipe',
                        message: error.body.message,
                        variant: 'error'
                    })
               );
          });
    }

    ingest3(event) {
        createDataflowJob({ dataflowJob: { dataflowId: '02K78000000AX0YEAW', command: this.command } })
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Recipe Started',
                        variant: 'success'
                    })
                );
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error starting recipe',
                        message: error.body.message,
                        variant: 'error'
                    })
               );
          });
    }
}