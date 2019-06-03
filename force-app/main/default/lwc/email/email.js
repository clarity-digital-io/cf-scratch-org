import { LightningElement, api } from 'lwc';

export default class Email extends LightningElement {

    @api type
    @api title
    @api required
    @api id
    @api options
    @api flow

    @api value

    changeHandler(event) {
        console.log('changeHandler', JSON.stringify(event.detail), event.target.value)
        // Prevents the anchor element from navigating to a URL.
        event.preventDefault();

        // Creates the event with the contact ID data.
        const selectedEvent = new CustomEvent('save', { detail: { value: event.target.value, id: this.id }});

        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
    }

}