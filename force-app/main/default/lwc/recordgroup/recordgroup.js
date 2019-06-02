import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Recordgroup extends LightningElement {

    @api type
    @api title
    @api required
    @api id
    @api options
    @api flow
    @api recordgroupobject

    @track modal = false;
    @track svg

    @track data = [];
    @track columns = columns;

    handleSuccess(event) {

        const evt = new ShowToastEvent({
            title: `${this.recordgroupobject} created`,
            message: "Record ID: "+ event.detail.id,
            variant: "success"
        });
        
        let value = addDataDetail(event.detail); 
        
        this.data = this.data.concat([value]);

        this.dispatchEvent(evt);
        this.closeModal();
    }

    openModal() {    
        this.modal = true;
    }
 
    closeModal() {    
        this.modal = false;
    }
}

const addDataDetail = ({ apiName, fields, id }) => {

    return ['Subject', 'Status', 'AccountId'].reduce((accum, current, i) => {

        let newAccum = { ...accum };

        newAccum[current] = fields[current].value;

        return newAccum;

    }, { id: id });
    
}

const columns = [
    {label: 'Subject', fieldName: 'Subject', type: 'text'},
    {label: 'Status', fieldName: 'Status', type: 'text'},
];
