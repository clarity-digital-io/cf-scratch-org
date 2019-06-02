import { LightningElement, api } from 'lwc';

export default class Comment extends LightningElement {

    @api type
    @api title
    @api maxLength
    @api required
    @api id
    @api options
    @api flow

    @api value

}