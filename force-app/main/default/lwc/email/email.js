import { LightningElement, api } from 'lwc';

export default class Email extends LightningElement {

    @api type
    @api title
    @api required
    @api id
    @api options
    @api flow

    @api value

}