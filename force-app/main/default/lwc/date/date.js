import { LightningElement, api } from 'lwc';

export default class Date extends LightningElement {

    @api type
    @api title
    @api required
    @api questionid

    @api value

    blurHandler(event) {
        event.preventDefault();

        const selectedEvent = new CustomEvent('save', { detail: { Answer__c: event.target.value, Clarity_Form_Question__c: this.questionid, save: true }});

        this.dispatchEvent(selectedEvent);
    }

}