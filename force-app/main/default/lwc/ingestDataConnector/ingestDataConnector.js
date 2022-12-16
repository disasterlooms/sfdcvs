import { LightningElement, api } from 'lwc';
import { ingestDataConnector } from 'lightning/analyticsWaveApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class IngestDataConnector extends LightningElement {
    @api CMS;
    
    ingest(event) {
        ingestDataConnector({ connectorIdOrApiName : '0It780000004CB4CAM' } )
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Data Connector Ingested',
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
    }
}