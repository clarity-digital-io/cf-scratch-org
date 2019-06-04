import { LightningElement, api } from 'lwc';

export default class Slider extends LightningElement {

    @api type
    @api title
    @api minrange
    @api maxrange
    @api step
    @api required
    @api questionid

    @api value

    changeHandler(event) {

        console.log('changeHandler', JSON.stringify(event.detail), event.target.value)

        event.preventDefault();

        const selectedEvent = new CustomEvent('save', { detail: { Answer__c: event.target.value, Clarity_Form_Question__c: this.questionid, save: true }});

        this.dispatchEvent(selectedEvent);

    }

}