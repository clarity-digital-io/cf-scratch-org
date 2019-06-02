import { LightningElement, api } from 'lwc';

export default class Recordgroup extends LightningElement {

    @api type
    @api title
    @api required
    @api id
    @api options
    @api flow
    @api recordgroupobject

    constructor() {
        super(); 
    }

    connectedCallback() {
        console.log(this.recordgroupobject);
    }
}