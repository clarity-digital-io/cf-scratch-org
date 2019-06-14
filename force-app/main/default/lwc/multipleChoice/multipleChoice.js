import { LightningElement, api } from 'lwc';

export default class Multiplechoice extends LightningElement {

    @api type
    @api title
    @api required
    @api questionid
    @api options

    changeHandler(event) {
        event.preventDefault();

        const selectedEvent = new CustomEvent('save', { detail: { Answer__c: event.target.value, Clarity_Form_Question__c: this.questionid, save: true }});

        this.dispatchEvent(selectedEvent);
    }
}