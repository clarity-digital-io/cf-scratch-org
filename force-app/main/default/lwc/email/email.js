import { LightningElement, api } from 'lwc';

export default class Email extends LightningElement {

    @api type
    @api title
    @api required
    @api questionid

    @api value = ''

    blurHandler(event) {
        event.preventDefault();

        const selectedEvent = new CustomEvent('save', { detail: { Answer__c: event.target.value, Clarity_Form_Question__c: this.questionid, save: true }});

        this.dispatchEvent(selectedEvent);
    }

    renderedCallback() {

        if(this.questionid != null) {
            console.log(this.template.querySelectorAll("*"));
            this.template.querySelector("label.slds-form-element__label").style.color = '#fff';
        }

    }

}