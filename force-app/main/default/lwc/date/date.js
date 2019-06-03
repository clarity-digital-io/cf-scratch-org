import { LightningElement, api } from 'lwc';

export default class Date extends LightningElement {

    @api type
    @api title
    @api required
    @api id

    @api value

    blurHandler(event) {
        console.log('changeHandler', JSON.stringify(event.detail), event.target.value)

        event.preventDefault();

        const selectedEvent = new CustomEvent('save', { detail: { value: event.target.value, id: this.id, save: true }});

        this.dispatchEvent(selectedEvent);
    }

}