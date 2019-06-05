import { LightningElement, api, track, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';

export default class Useform extends NavigationMixin(LightningElement) {

    @api recordId;
    @api isPublished;

    @track record;

    @wire(getRecord, { recordId: '$recordId', fields: ['Clarity_Form__c.Status__c'] })

    wiredForm({ error, data }) {
        if (data) {

            this.record = data;

            this.isPublished = this.record.fields.Status__c.value == 'Published' ? true : false;

        } else if (error) {
            this.error = error;
        }
    }

    editForm() {

        this[NavigationMixin.Navigate]({
            type: "standard__component",
            attributes: {
                componentName: "c__FormBuilder"
            },
            state: {
                recordId: this.recordId
            }
        });

    }

    createResponse() {

        this[NavigationMixin.Navigate]({
            type: "standard__component",
            attributes: {
                componentName: "c__FormResponse"
            },
            state: {
                recordId: this.recordId
            }
        });

    }

}


