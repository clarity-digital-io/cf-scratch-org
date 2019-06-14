import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Connectedobject extends LightningElement {

    @api type
    @api title
    @api required
    @api id
    @api options
    @api flow

    handleSuccess(event) {

        const evt = new ShowToastEvent({
            title: `created`,
            message: "Record ID: "+ event.detail.id,
            variant: "success"
        });

        this.dispatchEvent(evt);
        
    }
}
