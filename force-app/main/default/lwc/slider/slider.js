import { LightningElement, api } from 'lwc';

export default class Slider extends LightningElement {

    @api type
    @api title
    @api minrange
    @api maxrange
    @api step
    @api required
    @api id
    @api options
    @api flow

    @api value

    handleChange(event) {
        console.log(event.target.value);
    }

}