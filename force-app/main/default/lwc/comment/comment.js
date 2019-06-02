import { LightningElement } from 'lwc';

export default class Comment extends LightningElement {

    @api type
    @api title
    @api required
    @api id
    @api options
    @api flow
    
}