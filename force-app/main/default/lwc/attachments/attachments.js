import { LightningElement, api } from 'lwc';

export default class Attachments extends LightningElement {

    @api formresponseid
    @api type
    @api title
    @api required
    @api id
    @api options
    @api flow

    get acceptedFormats() {
        return ['.pdf', '.png'];
    }

    handleUploadFinished(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;
        alert("No. of files uploaded : " + uploadedFiles.length);
    }

}