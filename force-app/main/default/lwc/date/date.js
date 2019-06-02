import { LightningElement, api } from 'lwc';

export default class Date extends LightningElement {

    @api type
    @api title
    @api required
    @api id
    @api flow

    @api value

}