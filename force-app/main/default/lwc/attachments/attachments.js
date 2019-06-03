import { LightningElement, api } from 'lwc';

export default class Attachments extends LightningElement {

    @api formresponseid
    @api type
    @api title
    @api required
    @api id

    get acceptedFormats() {
        return ['.pdf', '.png'];
    }

    handleUploadFinished(event) {
        const uploadedFiles = event.detail.files;

        const selectedEvent = new CustomEvent('save', { detail: { value: uploadedFiles, id: this.id, save: false }});

        this.dispatchEvent(selectedEvent);
    }

}