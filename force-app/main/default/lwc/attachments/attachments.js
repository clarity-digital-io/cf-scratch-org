import { LightningElement, api } from 'lwc';

export default class Attachments extends LightningElement {

    @api formresponseid
    @api type
    @api title
    @api required
    @api questionid

    get acceptedFormats() {
        return ['.pdf', '.png'];
    }

    handleUploadFinished(event) {
        const uploadedFiles = event.detail.files;

        const selectedEvent = new CustomEvent('save', { detail: { Answer__c: uploadedFiles, Clarity_Form_Question__c: this.questionid }});

        this.dispatchEvent(selectedEvent);
    }

}