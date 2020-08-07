import { api, track, LightningElement } from 'lwc';

export default class formAnswers extends LightningElement {
    @api recordId;
    @track data;
    @track columns;
    @track loading = true; 

}