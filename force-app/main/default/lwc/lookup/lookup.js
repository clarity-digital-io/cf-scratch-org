import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import lookupSearch from '@salesforce/apex/ClarityFormPreview.search';

export default class Lookup extends LightningElement {
    
    @api lookupobject;
    @api notifyViaAlerts = false;
    @track isMultiEntry = false;
    @track initialSelection = [];
    @track errors = [];

    handleLookupTypeChange(event) {
        this.initialSelection = [];
        this.errors = [];
        this.isMultiEntry = event.target.checked;
    }

    handleSearch(event) {

        lookupSearch(event.detail)
            .then(results => {
                this.template.querySelector('c-lightning-lookup').setSearchResults(results);
                sendEvent(this.template.querySelector('c-lightning-lookup').getSelection());
            })
            .catch(error => {
                this.notifyUser('Lookup Error', 'An error occured while searching with the lookup field.', 'error');
                this.errors = [error];
            });

    }

    handleSelectionChange() {
        this.errors = [];
    }

    notifyUser(title, message, variant) {

        const toastEvent = new ShowToastEvent({ title, message, variant });
        this.dispatchEvent(toastEvent);

    }

    sendEvent(selection) {

        console.log('sendEvent', JSON.stringify(selection))
    
        // event.preventDefault();

        // const selectedEvent = new CustomEvent('save', { detail: { value: event.target.value, id: this.id, save: true }});

        // this.dispatchEvent(selectedEvent);
    
    }
}