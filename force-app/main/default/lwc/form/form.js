import { LightningElement, track, api, wire } from 'lwc';
import preview from '@salesforce/apex/ClarityFormPreview.preview';

export default class ClarityForm extends LightningElement {
    
    @api recordId;
    @track form;
    @track questions;
    @track error;

    constructor() {
        super(); 
    }

    connectedCallback() {

        preview({ recordId: this.recordId })
            .then(result => {
                this.form = result['Form'][0];
                this.questions = sort(result['Questions']);
            })
            .catch(error => {
                this.error = error; 
            })

    }

}

const sort = (result) => {

    return result.sort((a, b) => {
        if(a.Order__c < b.Order__c) {
            return -1; 
        }
        if(a.Order__c > b.Order__c) {
            return 1; 
        }
    });

}
