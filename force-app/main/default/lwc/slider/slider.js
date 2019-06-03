import { LightningElement, api } from 'lwc';

export default class Slider extends LightningElement {

    @api type
    @api title
    @api minrange
    @api maxrange
    @api step
    @api required
    @api id

    @api value

    changeHandler(event) {

        console.log('changeHandler', JSON.stringify(event.detail), event.target.value)

        event.preventDefault();

        const selectedEvent = new CustomEvent('save', { detail: { value: event.target.value, id: this.id, save: true }});

        this.dispatchEvent(selectedEvent);

    }

}